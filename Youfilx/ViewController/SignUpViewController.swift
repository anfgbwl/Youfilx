//
//  SignUpViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "회원가입 페이지"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true


    }
    

}
