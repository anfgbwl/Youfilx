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
        
//        let url = API.baseUrl + "videos"
//        let apiParam = ["part":"snippet", "chart":"mostPopular", "maxResult":25, "regionCode":"KR", "key":API.key] as [String : Any]
//
//        AF.request(url, method: .get, parameters: apiParam).responseJSON(completionHandler: { respone in
//            debugPrint(respone)
//        })
    }
    
    private func loadVideo() {
        APIManager.shared.fetchVideos { [weak self] result in
            switch result {
            case .success(let data):
                if let json = data as? [String:Any],
                   let items = json["items"] as? [[String:Any]] {
                    for item in items {
                        if let snippet = item["snippet"] as? [String:Any],
                           let title = snippet["title"] as? String,
                           let thumbnails = snippet["thumbnails"] as? [String:Any],
                           let standard = thumbnails["standard"] as? [String:Any],
                           let thumbnailUrl = standard["url"] as? String,
                           let user = snippet["channelTitle"] as? String {
                            AF.request(thumbnailUrl).responseData { response in
                                switch response.result {
                                case .success(let data):
                                    if let image = UIImage(data: data) {
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
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - setupUI
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.title = "닉네임"
        
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
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Style1: 가로 동영상 2개 배치
//        let size = (self.view.frame.width/2) - 6
//        return CGSize(width: size, height: 100)
        // Style2: 가로 동영상 1개 배치
        let size = self.view.frame.width
        return CGSize(width: size, height: 220)
    }
    
    // Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 80
    }
    
    // Horizontal Spacing
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
}
