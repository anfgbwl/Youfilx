import UIKit
import Alamofire

class MyPageHistoryViewController: UIViewController {
    
    // 사용자 정보
    var user: User = loadUserFromUserDefaults()!
    
    // MARK: - Variables
    private var isLoadingData = false
    private var nextPageToken: String?
    private var thumbnails: [UIImage] = []
    private var channelImages: [UIImage] = []
    private var titles: [String] = []
    private var channelTitles: [String] = []
    private var viewCounts: [String] = []
    private var publishedAts: [String] = []
    private var watchHistory: [Video] = []
    
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Loading UI
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.color = .gray // 원하는 색상으로 설정
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        watchHistory = loadWatchHistory() ?? []
        loadVideoForWatchHistoryIfNeeded() // 뷰가 나타날 때 한 번만 호출
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // 시청한 비디오 목록을 가져와서 화면에 표시
//        watchHistory = loadWatchHistory() ?? []
//        loadVideoForWatchHistoryIfNeeded() // 뷰가 나타날 때 한 번만 호출
    }
    
    // MARK: - Load Account
    private func loadWatchHistory() -> [Video]? {
        // 사용자 정보를 UserDefaults에서 가져옴
        if let loadedUser = loadUserFromUserDefaults() {
            user = loadedUser
        }
        guard let watchedVideo = user.watchHistory else {
            return []
        }
        return watchedVideo
    }
    
    // MARK: - YouTube Video Load for Watch History
    private func loadVideoForWatchHistoryIfNeeded() {
        startLoading()
        print("시청 기록 순서 확인: \(watchHistory)")
        guard !isLoadingData else { return }
        isLoadingData = true

        // 비디오 정보를 가져오는 인덱스 변수
        var currentIndex = 0

        // 비디오 정보를 가져오는 함수
        func loadNextVideo() {
            if currentIndex < watchHistory.count {
                let video = watchHistory[currentIndex]
                let request = YoutubeAPI.videoInformation(video.id)

                AF.request(request).responseJSON { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success(let data):
//                        print(data)
                        if let json = data as? [String: Any], let items = json["items"] as? [[String: Any]], let item = items.first {
                            if let snippet = item["snippet"] as? [String: Any],
                               let statistics = item["statistics"] as? [String: Any],
                               let viewCount = statistics["viewCount"] as? String,
                               let publishedAt = snippet["publishedAt"] as? String,
                               let channelId = snippet["channelId"] as? String,
                               let title = snippet["title"] as? String,
                               let thumbnails = snippet["thumbnails"] as? [String: Any],
                               let maxres = thumbnails["maxres"] as? [String: Any],
                               let thumbnailUrl = maxres["url"] as? String,
                               let channelTitle = snippet["channelTitle"] as? String {
                                AF.request(thumbnailUrl).responseData { response in
                                    switch response.result {
                                    case .success(let data):
                                        if let image = UIImage(data: data) {
                                            // 배열에 순서대로 추가
                                            self.fetchChannelThumbnail(channelId) { channelImage in
                                                self.thumbnails.append(image)
                                                self.titles.append(title)
                                                self.channelTitles.append(channelTitle)
                                                self.viewCounts.append(viewCount)
                                                self.publishedAts.append(publishedAt)
                                            }
                                            // 다음 비디오 정보 가져오기
                                            currentIndex += 1
                                            loadNextVideo()
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
            } else {
                // 모든 비디오 정보를 가져온 후에 화면 업데이트
                self.isLoadingData = false
                self.collectionView.reloadData()

                stopLoading() // 로딩 종료
            }
        }
        // 첫 번째 비디오 정보 가져오기 시작
        loadNextVideo()
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
    
    // MARK: - setupUI
    private func setupUI() {
        self.title = "시청 기록"
        
        view.backgroundColor = .systemBackground
        
        // Navigation Bar
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.leftBarButtonItem?.tintColor = .red
        
        // CollectionView
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - 로딩 인디케이터 메서드
    private func startLoading() {
        view.addSubview(activityIndicatorView)
        
        let yOffset: CGFloat = -100.0
        activityIndicatorView.center = CGPoint(x: view.center.x, y: view.center.y + yOffset)
        
        activityIndicatorView.startAnimating()
        collectionView.isHidden = true
    }

    private func stopLoading() {
        activityIndicatorView.stopAnimating()
        collectionView.isHidden = false // 컬렉션 뷰를 다시 표시
    }
}

extension MyPageHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.identifier, for: indexPath) as? HomeViewCell else {
            fatalError("ERROR")
        }
        
        if indexPath.row < thumbnails.count {
            let image = thumbnails[indexPath.row]
            let channelImage = self.channelImages[indexPath.row]
            let title = titles[indexPath.row]
            let name = channelTitles[indexPath.row]
            let count = viewCounts[indexPath.row]
            let date = publishedAts[indexPath.row]
            cell.configure(video: image, image: channelImage, title: title, channelTitle: name, viewCount: count, publishedAt: date)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 디테일페이지에 넘겨주는 비디오 정보(id)
        let selectedVideo = watchHistory[indexPath.row].id
        navigationController?.pushViewController(DetailPageViewController(videoId: selectedVideo), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤이 끝에 도달할 때마다 호출되지 않도록 수정
    }
}

extension MyPageHistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width
        return CGSize(width: size, height: 220)
    }
    
    // Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 80
    }
}
