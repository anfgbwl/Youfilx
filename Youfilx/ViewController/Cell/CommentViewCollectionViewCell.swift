//
//  CommentViewCollectionViewCell.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/08.
//

import UIKit

final class CommentViewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CommentViewCollectionViewCell.self)
    
    private lazy var commentContainerStackView = UIStackView().and {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10
        $0.alignment = .top
    }
    private lazy var authorImageView = DImageView().and {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    private lazy var commentContextStackView = UIStackView().and {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 5
        $0.alignment = .leading
    }
    private lazy var authorIdLabel = UILabel().and {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16, weight: .light)
    }
    private lazy var commentContextLabel = UILabel().and {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.numberOfLines = 0
    }
    private lazy var likeContainerStackView = UIStackView().and {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 10
        $0.alignment = .center
    }
    private lazy var likeImageView = UIImageView().and {
        $0.image = .thumbUpNormal
    }
    private lazy var likeCountLabel = UILabel().and {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 18, weight: .regular)
    }
    private lazy var moreCommentButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CommentViewCollectionViewCell {
    
    private func configure() {
        addSubview(commentContainerStackView)
        [authorImageView, commentContextStackView].forEach {
            commentContainerStackView.addArrangedSubview($0)
        }
        [authorIdLabel, commentContextLabel, likeContainerStackView].forEach {
            commentContextStackView.addArrangedSubview($0)
        }
        [likeImageView, likeCountLabel].forEach {
            likeContainerStackView.addArrangedSubview($0)
        }
        
        layout()
    }
    
    private func layout() {
        commentContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentContainerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            commentContainerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            commentContainerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            commentContainerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            
            authorImageView.heightAnchor.constraint(equalToConstant: 30),
            authorImageView.widthAnchor.constraint(equalToConstant: 30),
            
            likeImageView.heightAnchor.constraint(equalToConstant: 30),
            likeImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func bind(_ commentInformation: CommentThreadInformation) {
        authorImageView.fetchImage(commentInformation.authorProfileImageUrl)
        authorIdLabel.text = "@\(commentInformation.authorChannelId)"
        commentContextLabel.text = commentInformation.textDisplay
        likeCountLabel.text = "\(commentInformation.likeCount)"
        if commentInformation.totalReplyCount > 0 {
            commentContextStackView.addArrangedSubview(moreCommentButton)
            moreCommentButton.setTitle("답글 \(commentInformation.totalReplyCount)", for: .normal)
            moreCommentButton.setTitleColor(.systemCyan, for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorImageView.image = nil
        authorIdLabel.text = ""
        commentContextLabel.text = ""
        likeCountLabel.text = "0"
        moreCommentButton.removeFromSuperview()
    }
}
