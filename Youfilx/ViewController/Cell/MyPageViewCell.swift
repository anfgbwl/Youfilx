//
//  MyPageViewCell.swift
//  Youfilx
//
//  Created by t2023-m0076 on 2023/09/06.
//

import UIKit

class MyPageViewCell: UITableViewCell {
    
    static let identifier = "MyPageViewCell"
    
    // MARK: - UI Components
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark.circle")
        iv.tintColor = .label
        iv.clipsToBounds = true
        return iv
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    // MARK: - Configure
    public func configure(image: UIImage, label: String) {
        self.image.image = image
        self.label.text = label
        self.setupUI()
    }
    
    // MARK: - setupUI
    private func setupUI() {
        self.contentView.addSubview(image)
        self.contentView.addSubview(label)
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            image.widthAnchor.constraint(equalToConstant: 30),
            image.heightAnchor.constraint(equalToConstant: 30),
            
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.image.trailingAnchor, constant: 20),
        ])
    }
}
