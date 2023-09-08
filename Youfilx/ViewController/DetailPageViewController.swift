//
//  DetailPageViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

@MainActor
final class DetailPageViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var stackView = UIStackView().and {
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 10
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private lazy var youtubeView = YoutubeView()
    private lazy var videoInformationStackView = BackgroundColorAlphaChangeLikeUIButtonWhenTappedUIStackView {
        //TODO: 자세한 정보 보여주는 뷰
    }.and {
        $0.backgroundColor = .black
        $0.distribution = .fill
        $0.alignment = .leading
        $0.axis = .vertical
        $0.spacing = 10
    }
    private lazy var videoTitleLabel = UILabel().and {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 26, weight: .bold)
        $0.numberOfLines = 0
    }
    private lazy var videoInformationsStackView = UIStackView().and {
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
        $0.spacing = 10
    }
    private lazy var videoInformationLabel = UILabel().and {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12, weight: .light)
    }
    private lazy var videoMoreInformationLabel = UILabel().and {
        $0.text = "더보기"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    private lazy var videoMakerStackView = UIStackView().and {
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.spacing = 10
        $0.backgroundColor = .black
    }
    private lazy var videoMakerImageView = DImageView().and {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    private lazy var videoMakerInformationStackView = UIStackView().and {
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
        $0.spacing = 10
    }
    private lazy var videoMakerNameLabel = UILabel().and {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    private lazy var videoMakerSubscriberCountLabel = UILabel().and {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12, weight: .thin)
    }
    private lazy var videoLikeButton = ImageChangableWhenSelectedButton(
        normalImage: .thumbUpNormal,
        selectedImage: .thumbUpFill,
        checked: { [weak self] checked in
            self?.likeAction(checked)
    }).and {
        $0.setTitle("1.6천", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
    }
    private lazy var videoCommentStackView = BackgroundColorAlphaChangeLikeUIButtonWhenTappedUIStackView {
        //TODO: 댓글 자세히 보기
    }.and {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.backgroundColor = .black
    }
    private lazy var videoCommentTitleStackView = UIStackView().and {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.spacing = 10
    }
    private lazy var videoCommentTitleLabel = UILabel().and {
        $0.text = "댓글"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    private lazy var videoCommentCountLabel = UILabel().and {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12, weight: .light)
    }
    private lazy var videoCommentContextStackView = UIStackView().and {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }
    private lazy var videoCommenterImageView = DImageView().and {
        $0.layer.cornerRadius = 11
        $0.clipsToBounds = true
    }
    private lazy var videoCommentLabel = UILabel().and {
        $0.textColor = .white
        $0.numberOfLines = 2
    }
    private lazy var videoCommentSeeMore = UIButton().and {
        $0.setImage(UIImage(systemName: "chevron.down")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
    }
    private let videoId: String
    private let apiManager = APIManager.shared
    private var currentVideo = Video()
    
    init(videoId: String) {
        self.videoId = videoId
        currentVideo.id = videoId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DetailPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        youtubeView.getCurrentTime { [weak self] currentTime in
            guard let self else {return}
            let currentTimeInt = Int(currentTime)
            guard var user = loadUserFromUserDefaults() else {return}
            guard var watchHistory = user.watchHistory else {return}
            guard let videoIndex = watchHistory.firstIndex(where: { $0.id == self.videoId }) else {
                return
            }
            var video = watchHistory[videoIndex]
            video.currentTime = currentTimeInt
            watchHistory[videoIndex] = video
            user.watchHistory = watchHistory
            saveUserToUserDefaults(user: user)
        }
    }
}

extension DetailPageViewController {
    
    private func configure() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        [youtubeView, videoInformationStackView, videoMakerStackView, videoCommentStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        [videoInformationLabel, videoMoreInformationLabel].forEach {
            videoInformationsStackView.addArrangedSubview($0)
        }
        [videoTitleLabel, videoInformationsStackView].forEach {
            videoInformationStackView.addArrangedSubview($0)
        }
        [videoMakerNameLabel, videoMakerSubscriberCountLabel].forEach {
            videoMakerInformationStackView.addArrangedSubview($0)
        }
        [videoMakerImageView, videoMakerInformationStackView, videoLikeButton].forEach {
            videoMakerStackView.addArrangedSubview($0)
        }
        [videoCommentTitleStackView, videoCommentContextStackView].forEach {
            videoCommentStackView.addArrangedSubview($0)
        }
        [videoCommentTitleLabel, videoCommentCountLabel].forEach {
            videoCommentTitleStackView.addArrangedSubview($0)
        }
        [videoCommenterImageView, videoCommentLabel, videoCommentSeeMore].forEach {
            videoCommentContextStackView.addArrangedSubview($0)
        }
        
        layout()
        prepareView(videoId: videoId)
        
        Task {
            await loadDatas()
        }
    }
    
    private func layout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        youtubeView.translatesAutoresizingMaskIntoConstraints = false
        
        videoMoreInformationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        videoMakerImageView.translatesAutoresizingMaskIntoConstraints = false
        videoMakerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        videoCommenterImageView.translatesAutoresizingMaskIntoConstraints = false
        videoCommentSeeMore.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
    
            youtubeView.heightAnchor.constraint(equalToConstant: 300),
            
            videoMoreInformationLabel.widthAnchor.constraint(equalToConstant: 50),
            
            videoMakerImageView.heightAnchor.constraint(equalToConstant: 30),
            videoMakerImageView.widthAnchor.constraint(equalToConstant: 30),
            
            videoCommenterImageView.heightAnchor.constraint(equalToConstant: 22),
            videoCommenterImageView.widthAnchor.constraint(equalToConstant: 22),
            videoCommentSeeMore.trailingAnchor.constraint(equalTo: videoCommentStackView.trailingAnchor, constant: -10),
            videoCommentSeeMore.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func prepareView(videoId: String) {
        
        stateSetting(videoId: videoId)
        
        youtubeView.loadYoutube(videoId: videoId)
        guard let user = loadUserFromUserDefaults() else {
            return
        }
        
        if let favoriteList = user.favoriteVideos {
            if favoriteList.map({ $0.id }).contains(videoId) {
                videoLikeButton.checkImageAdjust(true)
            } else {
                videoLikeButton.checkImageAdjust(false)
            }
        }

        guard let watchHistory = user.watchHistory else {
            return
        }
        guard let videoIndex = watchHistory.firstIndex(where: { $0.id == videoId }) else {
            return
        }
        let video = watchHistory[videoIndex]
        guard let videoStartTime = video.currentTime else {
            return
        }
        youtubeView.loadYoutube(videoId: videoId, startTime: videoStartTime, isAutoPlay: true)
        
    }
    
    private func stateSetting(videoId: String) {
        youtubeView.state = { [weak self] state in
            guard let self else {return}
            if state == .playing {
                guard var user = loadUserFromUserDefaults() else {
                    return
                }
                guard var watchHistory = user.watchHistory else {
                    return
                }
                if let videoIndex = watchHistory.firstIndex(where: { $0.id == videoId }) {
                    watchHistory.remove(at: videoIndex)
                }
                watchHistory = [self.currentVideo] + watchHistory
                user.watchHistory = watchHistory
                saveUserToUserDefaults(user: user)
            }
        }
    }
    
    private func loadDatas() async {
        do {
            let videoInformation = try await APIManager.shared.request(YoutubeAPI.videoInformation(videoId)).toObject(VideoInformationSearchResponse.self).toVideoInformation()
            videoTitleLabel.text = videoInformation.title
            videoInformationLabel.text = "조회수 \(videoInformation.viewCount)회 \(videoInformation.createdAt) \(videoInformation.tags.reduce("", { $0+" #"+$1 }))"
            videoMakerNameLabel.text = videoInformation.channelName
            videoLikeButton.setTitle("\(videoInformation.likeCount)", for: .normal)
            videoCommentCountLabel.text = "\(videoInformation.commentCount)"
            currentVideo.thumbnailImage = videoInformation.thumbnailURL
            currentVideo.title = videoInformation.title
            currentVideo.creatorNickname = videoInformation.channelName
            currentVideo.views = videoInformation.viewCount
            currentVideo.duration = videoInformation.duration
            let channelId = videoInformation.channelId
            let channelInformation = try await APIManager.shared.request(YoutubeAPI.channel(channelId)).toObject(ChannelResponse.self).toChannelInformation()
            videoMakerSubscriberCountLabel.text = channelInformation.subscriberCount
            videoMakerImageView.fetchImage(channelInformation.thumbnailURL)
            let commentInformation = try await apiManager.request(YoutubeAPI.commentThread(videoId)).toObject(CommentThreadResponse.self).toCommentThreadInformation()
            videoCommentLabel.text = commentInformation?.textDisplay
            videoCommenterImageView.fetchImage(commentInformation?.authorProfileImageUrl ?? "")
        } catch {
            print(error)
        }
    }
    
    private func likeAction(_ isChecked: Bool) {
        guard var user = loadUserFromUserDefaults() else {
            return
        }
        guard var favoriteList = user.favoriteVideos else {
            return
        }
        if isChecked {
            if let videoIndex = favoriteList.firstIndex(where: { $0.id == videoId }) {
                favoriteList.remove(at: videoIndex)
            }
            favoriteList = [currentVideo] + favoriteList
        } else {
            guard let videoIndex = favoriteList.firstIndex(where: { $0.id == videoId }) else {
                return
            }
            favoriteList.remove(at: videoIndex)
        }
        user.favoriteVideos = favoriteList
        saveUserToUserDefaults(user: user)
    }
    
}

extension UIImage {
    static let thumbUpNormal = UIImage(systemName: "hand.thumbsup")
    static let thumbUpFill = UIImage(systemName: "hand.thumbsup.fill")
}
