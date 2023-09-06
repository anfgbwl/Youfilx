//
//  DetailPageViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

final class DetailPageViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private lazy var youtubeView = YoutubeView()
    private lazy var videoInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .black
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    private lazy var videoTitleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.textColor = .white
        uiLabel.font = .systemFont(ofSize: 26, weight: .bold)
        return uiLabel
    }()
    private lazy var videoInformationsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    private lazy var videoInformationLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.textColor = .white
        uiLabel.font = .systemFont(ofSize: 12, weight: .light)
        return uiLabel
    }()
    private lazy var videoMoreInformationLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "더보기"
        uiLabel.textColor = .white
        uiLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return uiLabel
    }()
    
    private let videoId: String
    
    init(videoId: String) {
        self.videoId = videoId
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

        videoTitleLabel.text = "타이틀"
        videoInformationLabel.text = "조회수 4.8만회 1년 전 #Lovely #Haruy"
        
    }
}

extension DetailPageViewController {
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        [youtubeView, videoInformationStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        [videoInformationLabel, videoMoreInformationLabel].forEach {
            videoInformationsStackView.addArrangedSubview($0)
        }
        [videoTitleLabel, videoInformationsStackView].forEach {
            videoInformationStackView.addArrangedSubview($0)
        }
        
        layout()
        prepareView(videoId: videoId)
    }
    
    private func layout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        youtubeView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
            youtubeView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func prepareView(videoId: String) {
        youtubeView.loadYoutube(videoId: videoId)
    }
 
}

