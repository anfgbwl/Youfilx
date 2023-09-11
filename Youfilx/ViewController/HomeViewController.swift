//
//  HomeViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    // 사용자 정보
    var user: User = loadUserFromUserDefaults()!
    
    // MARK: - Variables
    private var isLoadingData = false
    private var nextPageToken: String?
    static var videoIds: [String] = []
    private var thumbnails: [UIImage] = []
    private var channelImages: [UIImage] = []
    private var titles: [String] = []
    private var channelTitles: [String] = []
    private var viewCounts: [String] = []
    private var publishedAts: [String] = []

    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("유저 : \(user.isLoggedIn)")
        print(UserDefaults.standard.bool(forKey: "isLoggedIn"))
        setupUI()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        loadVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 수정된 정보를 가져와 화면에 표시
        loadAccount()
    }
    
    // MARK: - Load Account
    // 사용자 정보를 다시 불러와서 화면에 표시하는 메서드
    private func loadAccount() {
        // 사용자 정보를 UserDefaults에서 가져옴
        if let loadedUser = loadUserFromUserDefaults() {
            user = loadedUser
            self.navigationItem.rightBarButtonItems?[1].title = "\(user.nickname)님"
        }
    }
    
    // MARK: - YouTube Video Load
    private func loadVideo(pageToken: String? = nil) {
        guard !isLoadingData else { return }
        isLoadingData = true

        // YouTube API mostPopular 요청 생성
        let request = YoutubeAPI.mostPopularVideos(pageToken)

        AF.request(request).responseJSON { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                print(data)
                if let videoInfo = data as? [String: Any], let items = videoInfo["items"] as? [[String: Any]] {
                    for item in items {
                        if let id = item["id"] as? String,
                           !HomeViewController.videoIds.contains(id),
                           let snippet = item["snippet"] as? [String: Any],
                           let publishedAt = snippet["publishedAt"] as? String,
                           let channelId = snippet["channelId"] as? String,
                           let title = snippet["title"] as? String,
                           let thumbnails = snippet["thumbnails"] as? [String: Any],
                           let maxres = thumbnails["maxres"] as? [String: Any],
                           let url = maxres["url"] as? String,
                           let channelTitle = snippet["channelTitle"] as? String,
                           let statistics = item["statistics"] as? [String: Any],
                           let viewCount = statistics["viewCount"] as? String {
                            AF.request(url).responseData { response in
                                switch response.result {
                                case .success(let data):
                                    if let image = UIImage(data: data) {
                                        self.fetchChannelThumbnail(channelId) { channelImage in
                                            HomeViewController.videoIds.append(id)
                                            self.thumbnails.append(image)
                                            self.titles.append(title)
                                            self.channelTitles.append(channelTitle)
                                            self.viewCounts.append(viewCount)
                                            self.publishedAts.append(publishedAt)
                                            DispatchQueue.main.async {
                                                self.collectionView.reloadData()
                                            }
                                        }
                                    } else {
                                        print("🚫 Failed to convert data to UIImage")
                                    }
                                case .failure(let error):
                                    print("🚫 Image download error: \(error)")
                                }
                            }
                        }
                    }
                    self.nextPageToken = videoInfo["nextPageToken"] as? String
                }
            case .failure(let error):
                print("🚫 \(error)")
            }
            self.isLoadingData = false
        }
    }
    
    private func fetchChannelThumbnail(_ channelId: String, completion: @escaping (UIImage) -> Void) {
        // YouTube API 채널 정보 요청 생성
        let request = YoutubeAPI.channel(channelId)
        
        AF.request(request).responseDecodable(of: ChannelResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let channelResponse):
                if let channelInformation = channelResponse.toChannelInformation() {
                    // channelInformation.thumbnailURL를 사용하여 채널 썸네일을 가져옴
                    if let thumbnailUrl = URL(string: channelInformation.thumbnailURL) {
                        AF.request(thumbnailUrl).responseData { response in
                            switch response.result {
                            case .success(let data):
                                if let channelImage = UIImage(data: data) {
                                    self.channelImages.append(channelImage)
                                    completion(channelImage)
                                } else {
                                    print("🚫 Failed to convert data to UIImage")
                                }
                            case .failure(let error):
                                print("🚫 Image download error: \(error)")
                            }
                        }
                    }
                }
            case .failure(let error):
                print("🚫 \(error)")
            }
        }
    }
    
    private func loadMoreData() {
        loadVideo(pageToken: nextPageToken)
    }
  
    // MARK: - setupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Navigation Bar
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "youflix_logo"), style: .plain, target: self, action: #selector(didTapLogo))
        navigationItem.leftBarButtonItem?.tintColor = .red
        
        let firstButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearch))
        firstButton.tintColor = .white
        let secondButton = UIBarButtonItem(title: "\(user.nickname)님", style: .plain, target: nil, action: nil)
        secondButton.tintColor = .white
        secondButton.isSelected = false
        navigationItem.rightBarButtonItems = [firstButton, secondButton]
        
        // CollectionView
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    @objc private func didTapLogo() {
        print("☝️ Logo tapped!")
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc private func didTapSearch() {
        print("☝️ SearchButton tapped!")
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.identifier, for: indexPath) as? HomeViewCell else {
            fatalError("ERROR")
        }
        let image = self.thumbnails[indexPath.row]
        let channelImage = self.channelImages[indexPath.row]
        let title = self.titles[indexPath.row]
        let name = self.channelTitles[indexPath.row]
        let count = self.viewCounts[indexPath.row]
        let date = self.publishedAts[indexPath.row]
        cell.configure(video: image, image: channelImage, title: title, channelTitle: name, viewCount: count, publishedAt: date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 디테일페이지에 넘겨주는 비디오 정보(id)
        let selectedVideo = HomeViewController.videoIds[indexPath.row]
        navigationController?.pushViewController(DetailPageViewController(videoId: selectedVideo), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - scrollViewHeight {
            if !isLoadingData { loadMoreData() }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.width
        return CGSize(width: size, height: 220)
    }
    
    // Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 80
    }
}
