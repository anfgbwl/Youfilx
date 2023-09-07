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
    
    private let channelTitle: UILabel = {
        let name = UILabel()
        name.text = "channelName"
        name.textColor = .secondaryLabel
        let newFont = UIFont.systemFont(ofSize: 13.0)
        name.font = newFont
        name.textAlignment = .left
        return name
    }()
    
    private let viewCount: UILabel = {
        let count = UILabel()
        count.text = "viewCount"
        count.textColor = .secondaryLabel
        let newFont = UIFont.systemFont(ofSize: 13.0)
        count.font = newFont
        count.textAlignment = .left
        return count
    }()
    
    private let publishedAt: UILabel = {
        let date = UILabel()
        date.text = "nickname"
        date.textColor = .secondaryLabel
        let newFont = UIFont.systemFont(ofSize: 13.0)
        date.font = newFont
        date.textAlignment = .left
        return date
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [channelTitle, viewCount, publishedAt])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, labelStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 3
        return stackView
    }()
    
    
    // MARK: - Configure
    public func configure(video: UIImage, image: UIImage, title: String, channelTitle: String, viewCount: String, publishedAt: String) {
        self.thumbnailImage.image = video
        self.userImage.image = image
        self.title.text = title
        self.channelTitle.text = channelTitle
        self.viewCount.text = customFormattedViewsCount(viewCount)
        self.publishedAt.text = timeAgoSinceDate(publishedAt)
        self.setupUI()
    }
    
    // MARK: - ViewCount Format
    private func customFormattedViewsCount(_ viewsCount: String) -> String {
        if let viewsCount = Int(viewsCount) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 1
            
            if viewsCount >= 10000 {
                let viewsInTenThousand = Double(viewsCount) / 10000.0
                return numberFormatter.string(from: NSNumber(value: viewsInTenThousand))! + "만회"
            } else if viewsCount >= 1000 {
                let viewsInThousand = Double(viewsCount) / 1000.0
                return numberFormatter.string(from: NSNumber(value: viewsInThousand))! + "천회"
            } else {
                return "\(viewsCount)회"
            }
        } else {
            return "조회수 로드 오류"
        }
    }
    
    // MARK: - Date Format
    private func timeAgoSinceDate(_ isoDateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        
        guard let date = dateFormatter.date(from: isoDateString) else {
            return "Invalid Date"
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: currentDate)
        
        if let year = components.year, year > 0 {
            return "\(year)년 전"
        } else if let month = components.month, month > 0 {
            return "\(month)개월 전"
        } else if let day = components.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else if let second = components.second, second > 0 {
            return "\(second)초 전"
        } else {
            return "방금 전"
        }
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
        self.addSubview(titleStackView)
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: self.topAnchor),
            thumbnailImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thumbnailImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbnailImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            userImage.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 10),
            userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            userImage.widthAnchor.constraint(equalToConstant: 50),
            userImage.heightAnchor.constraint(equalToConstant: 50),
            
            titleStackView.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 10),
            titleStackView.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            titleStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImage.image = nil
        self.userImage.image = nil
    }
}
