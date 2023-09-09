//
//  MyPageViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

class MyPageViewController: UIViewController {
    
    // 사용자 정보
    var user: User = loadUserFromUserDefaults()!
    
    // MARK: - Variables
    private let setting: [(UIImage, String)] = [
        (UIImage(systemName: "person.crop.circle")!, "회원정보"),
        (UIImage(systemName: "heart.circle")!, "찜한영상"),
        (UIImage(systemName: "tv.circle")!, "시청기록"),
        (UIImage(systemName: "person.crop.circle.badge.minus")!, "로그아웃"),
        (UIImage(systemName: "person.crop.circle.badge.xmark")!, "회원탈퇴"),
    ]

    // MARK: - UI Componenets
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "profile_placeholder.png")
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
        
        loadAccount()
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 수정된 정보를 가져와 화면에 표시
        loadAccount()
    }
    
    // MARK: - Load Account
    // 사용자 정보를 다시 불러와서 화면에 표시하는 메서드
    private func loadAccount() {
        // 사용자 정보를 UserDefaults에서 가져옴
        let user = loadUserFromUserDefaults()

        if let imageData = user?.image, let profileImage = UIImage(data: imageData) {
            self.profileImage.image = profileImage
        } else {
            // 이미지가 nil이면 placeholder 이미지를 설정
            self.profileImage.image = UIImage(named: "profile_placeholder.png")
        }
        self.profileName.text = user?.nickname
        self.profileId.text = user?.id
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
        return 50 // 높이 오류
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
            // 로그아웃 확인 팝업 표시
            let alert = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
                // 사용자 로그아웃 처리
                self?.performLogout()
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        case 4:
            // 회원탈퇴 기능
            let alert = UIAlertController(title: "회원탈퇴", message: "회원 탈퇴하시겠습니까??", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
                // 사용자 회원 탈퇴 처리
                self?.performResign()
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }

    // 사용자 로그아웃 처리
    func performLogout() {
        // 로그아웃 상태로 업데이트
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        // 기존 사용자 정보 초기화
        var user = loadUserFromUserDefaults()
        user?.isLoggedIn = false
        saveUserToUserDefaults(user: user!)
        
        // 로그인 화면으로 이동
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.showLoginViewController()
        }
    }
    
    // 사용자 로그아웃 처리
    func performResign() {
        // 로그아웃 상태로 업데이트
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        
        // 로그인 화면으로 이동
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.showLoginViewController()
        }
    }
    
}
