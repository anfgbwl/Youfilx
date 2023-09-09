//
//  MyPageFavoriteViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit
import Alamofire

class MyPageFavoriteViewController: UIViewController {
    
    // 사용자 정보
    var user: User = loadUserFromUserDefaults()!

    // MARK: - Variables
    private var videos: [Video] = []
    static var videoIds: [String] = []

    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let favoriteVideos = user.favoriteVideos {
            videos = favoriteVideos
        }
        self.collectionView.reloadData()
    }
    
    // MARK: - setupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Navigation Bar
        self.navigationItem.title = "찜한영상"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = ""
        
        // CollectionView
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

extension MyPageFavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.favoriteVideos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.identifier, for: indexPath) as? HomeViewCell else {
            fatalError("ERROR")
        }
        let video = videos[indexPath.row]
        
        if let imageUrl = URL(string: video.thumbnailImage) {
            let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let imageData = data, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        let title = video.title
                        let name = video.creatorNickname
                        let count = "\(video.views)"
                        let date = video.uploadDate
                        // 채널 아이디를 사용하여 채널 정보를 가져옴
                        self.fetchChannelInfo(forChannelId: video.channelId) { channelInfo in
                            if let channelInfo = channelInfo {
                                // 채널 정보를 활용하여 cell.configure 호출
                                if let channelImageUrl = URL(string: channelInfo.snippet.thumbnails.default.url) {
                                    let channelImageTask = URLSession.shared.dataTask(with: channelImageUrl) { (channelImageData, _, _) in
                                        if let channelImageData = channelImageData, let channelImage = UIImage(data: channelImageData) {
                                            DispatchQueue.main.async {
                                                cell.configure(video: image, image: channelImage, title: title, channelTitle: name, viewCount: count, publishedAt: date)
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                cell.configure(video: image, image: UIImage(named: "person.fill")!, title: title, channelTitle: name, viewCount: count, publishedAt: date)
                                            }
                                            print("🚫 채널 이미지 로드 오류: \(indexPath)")
                                        }
                                    }
                                    channelImageTask.resume()
                                } else {
                                    DispatchQueue.main.async {
                                        cell.configure(video: image, image: UIImage(named: "person.fill")!, title: title, channelTitle: name, viewCount: count, publishedAt: date)
                                    }
                                    print("🚫 채널 이미지 URL 오류: \(indexPath)")
                                }
                            } else {
                                // 채널 정보를 가져오지 못한 경우에 대한 처리
                                DispatchQueue.main.async {
                                    cell.configure(video: image, image: UIImage(named: "person.fill")!, title: title, channelTitle: name, viewCount: count, publishedAt: date)
                                }
                                print("🚫 채널 정보 로드 오류: \(indexPath)")
                            }
                        }
                    }
                } else {
                    print("🚫 썸네일 이미지 로드 오류: \(indexPath)")
                }
            }
            task.resume()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 디테일페이지에 넘겨주는 비디오 정보(id)
        let selectedVideo = videos[indexPath.item].id
        navigationController?.pushViewController(DetailPageViewController(videoId: selectedVideo), animated: true)
    }
    
}

extension MyPageFavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.width
        return CGSize(width: size, height: 220)
    }
    
    // Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 80
    }
}

extension MyPageFavoriteViewController {
    private func fetchChannelInfo(forChannelId channelId: String, completion: @escaping (ChannelResponse.ChannelItem?) -> Void) {
        let request = YoutubeAPI.channel(channelId)

        AF.request(request).responseDecodable(of: ChannelResponse.self) { response in
            switch response.result {
            case .success(let channelResponse):
                if let channelItem = channelResponse.items.first {
                    completion(channelItem)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("🚫 채널 정보 로드 오류: \(error)")
                completion(nil)
            }
        }
    }
}
