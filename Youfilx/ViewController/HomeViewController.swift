//
//  HomeViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    // MARK: - Variables
    private var nextPageToken: String?
    static var videoIds: [String] = []
    private var thumbnails: [UIImage] = []
    private var titles: [String] = []
    private var users: [String] = []

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
        
        setupUI()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        loadVideo()
    }
    
    // MARK: - YouTube Video Load
    private func loadVideo(pageToken: String? = nil) {
        APIManager.shared.fetchVideos(pageToken: nextPageToken ?? "") { [weak self] result in
            switch result {
            case .success(let data):
                if let json = data as? [String:Any],
                   let items = json["items"] as? [[String:Any]] {
                    for item in items {
                        if let id = item["id"] as? String,
                           let snippet = item["snippet"] as? [String:Any],
                           let title = snippet["title"] as? String,
                           let thumbnails = snippet["thumbnails"] as? [String:Any],
                           let standard = thumbnails["standard"] as? [String:Any],
                           let thumbnailUrl = standard["url"] as? String,
                           let user = snippet["channelTitle"] as? String {
                            AF.request(thumbnailUrl).responseData { response in
                                switch response.result {
                                case .success(let data):
                                    if let image = UIImage(data: data) {
                                        HomeViewController.videoIds.append(id)
                                        self?.thumbnails.append(image)
                                        self?.titles.append(title)
                                        self?.users.append(user)
                                        DispatchQueue.main.async {
                                            self?.collectionView.reloadData()
                                        }
                                    } else {
                                        print("Failed to convert data to UIImage")
                                    }
                                case .failure(let error):
                                    print("Image download error: \(error)")
                                }
                            }
                        }
                    }
                    self?.nextPageToken = json["nextPageToken"] as? String
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func loadMoreData() {
        loadVideo(pageToken: nextPageToken)
    }
  
    // MARK: - setupUI
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.title = "삼인조"
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
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
        let title = self.titles[indexPath.row]
        let user = self.users[indexPath.row]
        cell.configure(video: image, image: image, title: title, name: user)
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
            loadMoreData()
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
