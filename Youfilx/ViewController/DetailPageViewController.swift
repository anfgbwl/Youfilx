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

}

extension DetailPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()

    }
}

extension DetailPageViewController {
    
    private func configure() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [youtubeView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        layout()
        prepareView(videoId: "jOTfBlKSQYY")
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

