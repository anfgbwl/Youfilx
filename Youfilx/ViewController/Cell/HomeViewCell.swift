//
//  HomeViewCell.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

class HomeViewCell: UICollectionViewCell {
    
    static let identifier = "HomeViewCell"
    
    // MARK: - UIConponents
    private let thumbnailImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .white
        iv.clipsToBounds = true
        return iv
    }()
    
    private let userImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "person")
        iv.tintColor = .white
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        return iv
    }()
    
    private let title: UILabel = {
        let title = UILabel()
        title.text = "title"
        title.textColor = .label
        title.textAlignment = .left
        title.numberOfLines = 2
        return title
    }()
    
    private let user: UILabel = {
        let name = UILabel()
        name.text = "nickname"
        name.textColor = .secondaryLabel
        let newFont = UIFont.systemFont(ofSize: 13.0)
        name.font = newFont
        name.textAlignment = .left
        return name
    }()
    
    
    // MARK: - Configure
    public func configure(video: UIImage, image: UIImage, title: String, name: String) {
        self.thumbnailImage.image = video
        self.userImage.image = image
        self.title.text = title
        self.user.text = name
        self.setupUI()
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
    }
    
    // MARK: - setupUI
    private func setupUI() {
        self.addSubview(thumbnailImage)
        self.addSubview(userImage)
        self.addSubview(title)
        self.addSubview(user)
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        user.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: self.topAnchor),
            thumbnailImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thumbnailImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbnailImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            userImage.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 10),
            userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            userImage.widthAnchor.constraint(equalToConstant: 50),
            userImage.heightAnchor.constraint(equalToConstant: 50),
            
            title.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            
            user.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            user.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            user.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImage.image = nil
        self.userImage.image = nil
    }
}
