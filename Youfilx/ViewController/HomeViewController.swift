//
//  HomeViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

class HomeViewController: UIViewController {

    let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .red
        setupUI()
 
    }
    
    func setupUI() {
        loginButton.backgroundColor = UIColor.white
        
        view.addSubview(loginButton)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 500).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        loginButton.setTitle("로그인 화면으로 이동", for: .normal)
        loginButton.addTarget(self, action: #selector(moveToLoginViewController), for: .touchUpInside)
    }
    
    @objc func moveToLoginViewController() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }

}
