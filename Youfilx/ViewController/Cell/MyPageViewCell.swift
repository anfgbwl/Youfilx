//
//  MyPageViewCell.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/06.
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [image, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Configure
    public func configure(image: UIImage, label: String) {
        self.image.image = image
        self.label.text = label
        self.setupUI()
    }
    
    // MARK: - setupUI
    private func setupUI() {
        self.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
        ])
    }
}
