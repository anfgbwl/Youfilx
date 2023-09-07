//
//  SearchViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/06.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    // MARK: - Variables
    static var searchText: String = ""
    private var isLoadingData = false
    private var nextPageToken: String?
    static var videoIds: [String] = []
    private var thumbnails: [UIImage] = []
    private var titles: [String] = []
    private var channelTitles: [String] = []
    private var viewCounts: [String] = []
    private var publishedAts: [String] = []

    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "YouTube 검색"
        return search
    }()
    
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
        searchBar.delegate = self
    }
    
    // MARK: - YouTube Video Load
    private func loadVideo(pageToken: String? = nil) {
        guard !isLoadingData else { return }
        isLoadingData = true
        
        // YouTube API search 요청 생성
        let request = YoutubeAPI.searchVideos(pageToken)

        AF.request(request).responseJSON { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                print("✅ searchVideos request: success")
                if let json = data as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    for item in items {
                        if let id = item["id"] as? [String: Any],
                           let videoId = id["videoId"] as? String,
                           !SearchViewController.videoIds.contains(videoId),
                           let snippet = item["snippet"] as? [String: Any],
                           let publishedAt = snippet["publishedAt"] as? String,
                           let title = snippet["title"] as? String,
                           let thumbnails = snippet["thumbnails"] as? [String: Any],
                           let medium = thumbnails["medium"] as? [String: Any],
                           let thumbnailUrl = medium["url"] as? String,
                           let channelTitle = snippet["channelTitle"] as? String {
                            AF.request(thumbnailUrl).responseData { response in
                                switch response.result {
                                case .success(let data):
                                    if let image = UIImage(data: data) {
                                        SearchViewController.videoIds.append(videoId)
                                        self.thumbnails.append(image)
                                        self.titles.append(title)
                                        self.channelTitles.append(channelTitle)
                                        self.publishedAts.append(publishedAt)
                                        
                                        // viewCount load 오류로 임시 설정
                                        self.viewCounts.append("1")
//                                        self.fetchVideoViewCounts(videoId)
                                        DispatchQueue.main.async {
                                            self.collectionView.reloadData()
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
                    self.nextPageToken = json["nextPageToken"] as? String
                }
            case .failure(let error):
                print("🚫 \(error)")
            }
            self.isLoadingData = false
        }
    }
    
    private func fetchVideoViewCounts(_ videoId: String) {
        let request = YoutubeAPI.videoInformation(videoId)
        
        AF.request(request).responseJSON { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                print("✅ searchVideoLoad request: success")
                if let videoInfo = data as? [String: Any],
                   let statistics = videoInfo["statistics"] as? [String: Any],
                   let viewCount = statistics["viewCount"] as? String {
                    self.viewCounts.append(viewCount)
                }
            case .failure(let error):
                print("🚫 searchVideoLoad request: \(error)")
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
        self.navigationItem.titleView = searchBar
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            SearchViewController.searchText = text
            print("🔍 검색어: \(SearchViewController.searchText)")
        }
        loadVideo()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.identifier, for: indexPath) as? HomeViewCell else {
            fatalError("ERROR")
        }
        let image = self.thumbnails[indexPath.row]
        let title = self.titles[indexPath.row]
        let name = self.channelTitles[indexPath.row]
        let count = self.viewCounts[indexPath.row]
        let date = self.publishedAts[indexPath.row]
        cell.configure(video: image, image: image, title: title, channelTitle: name, viewCount: count, publishedAt: date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 디테일페이지에 넘겨주는 비디오 정보(id)
        let selectedVideo = SearchViewController.videoIds[indexPath.row]
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

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.width
        return CGSize(width: size, height: 220)
    }
    
    // Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 80
    }
}
