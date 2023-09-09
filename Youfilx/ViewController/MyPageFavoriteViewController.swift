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
        return user.favoriteVideos!.count
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
                        cell.configure(video: image, image: image, title: title, channelTitle: name, viewCount: count, publishedAt: date)
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
