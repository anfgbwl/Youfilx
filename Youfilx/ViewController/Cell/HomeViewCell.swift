//
//  HomeViewCell.swift
//  Youfilx
//
//  Created by t2023-m0076 on 2023/09/04.
//

import UIKit

class HomeViewCell: UICollectionViewCell {
    
    static let identifier = "HomeViewCell"
    
    // MARK: - UIConponents
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .white
        iv.clipsToBounds = true
        return iv
    }()
    
    private let title: UILabel = {
        let title = UILabel()
        title.text = "영상 타이틀"
        title.textColor = .label
        title.textAlignment = .center
        return title
    }()
    
    
    // MARK: - Configure
    public func configure(with image: UIImage, and label: String) {
        self.imageView.image = image
        self.title.text = label
        self.setupUI()
    }
    
    // MARK: - setupUI
    private func setupUI() {
        self.addSubview(imageView)
        self.addSubview(title)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
