//
//  MyPageViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

class MyPageViewController: UIViewController {
    
    // MARK: - Variables
    private let setting: [(UIImage, String)] = [
        (UIImage(systemName: "person.crop.circle")!, "회원정보"),
        (UIImage(systemName: "heart.circle")!, "찜한영상"),
        (UIImage(systemName: "tv.circle")!, "시청기록"),
        (UIImage(systemName: "person.crop.circle.badge.xmark")!, "로그아웃"),
    ]

    // MARK: - UI Componenets
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "1")
        iv.tintColor = .red
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    private let profileName: UILabel = {
        let label = UILabel()
        label.text = "nickname"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let profileId: UILabel = {
        let label = UILabel()
        label.text = "id"
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .systemGray
        tableView.register(MyPageViewCell.self, forCellReuseIdentifier: MyPageViewCell.identifier)
        return tableView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileName, profileId])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImage, labelStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - setupUI
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        // Navigation Bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "youflix_logo"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .red
        
        self.view.addSubview(profileStackView)
        self.view.addSubview(tableView)
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // profileStackView
            profileStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            profileStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageViewCell.identifier, for: indexPath) as? MyPageViewCell else {
            fatalError("ERROR")
        }
        cell.backgroundColor = .systemBackground
        cell.selectionStyle = .none
        let image = setting[indexPath.row].0
        let label = setting[indexPath.row].1
        cell.configure(image: image, label: label)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(MyPageUserInfoViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(MyPageFavoriteViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(MyPageHistoryViewController(), animated: true)
        case 3:
            break
            // Logout Action
        default:
            break
        }
    }
}
