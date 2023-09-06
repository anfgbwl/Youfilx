//
//  SignUpViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    // MARK: - 회원가입 레이블
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        return label
    }()
    
    // MARK: - 이메일 텍스트 필드 뷰
    private lazy var emailView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(emailTextField)
        return view
    }()
    
    // 이메일 텍스트 필드
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 40
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .emailAddress
        tf.attributedPlaceholder = NSAttributedString(string: "이메일을 입력하세요", attributes: [.foregroundColor: UIColor.white])
        tf.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        // Delegate를 설정하여 포커스 상태 변화 감지
        //        tf.delegate = self
        
        return tf
    }()
    
    
    // MARK: - 비밀번호 텍스트 필드 뷰
    private lazy var passwordView: UIView = {
        let view = UIView()
        view.frame.size.height = 48
        view.backgroundColor = .gray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(passwordTextField)
        view.addSubview(passwordCheckButton)
        return view
    }()
    
    // 패스워드 텍스트필드
    private lazy var passwordTextField = {
        let tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = false // false로 했는데도.. 수정할 때마다 내용이 사라짐...
        tf.textContentType = .none
        tf.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: [.foregroundColor: UIColor.white])
        tf.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)

        // Delegate를 설정하여 포커스 상태 변화 감지
        //        tf.delegate = self
        return tf
    }()
    
    // 패스워드에 "표시" 버튼
    private let passwordCheckButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName:"eye.fill"),for: .normal)
        button.tintColor = .white
        
        
        return button
    }()
    
    // MARK: - 패스워드 컨펌 텍스트 필드 뷰
    private lazy var passwordConfirmView: UIView = {
        let view = UIView()
        view.frame.size.height = 48
        view.backgroundColor = .gray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(passwordConfirmTextField)
        view.addSubview(passwordConfirmCheckButton)
        return view
    }()
    
    // 패스워드 컨펌 텍스트필드
    private lazy var passwordConfirmTextField = {
        let tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = false // false로 했는데도.. 수정할 때마다 내용이 사라짐...
        tf.textContentType = .none
        tf.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: [.foregroundColor: UIColor.white])
        tf.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        // Delegate를 설정하여 포커스 상태 변화 감지
        //        tf.delegate = self
        return tf
    }()
    
    // 패스워드 컨펌 텍스트 필드 뷰에 "표시" 버튼
    private let passwordConfirmCheckButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName:"eye.fill"),for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    // MARK: - 스택 뷰
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailView, passwordView, passwordConfirmView, signUpButton])
        stack.spacing = 18
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - 회원가입 버튼
    private let signUpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //        button.isEnabled = false // 초기 비활성화
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // 이메일 텍스트 필드, 패스워드 필드, 패스워드 체크 필드, 회원가입 버튼 높이 설정
    private let viewHeight: CGFloat = 48
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        passwordCheckButton.addTarget(self, action: #selector(passwordCheck), for: .touchUpInside)
        passwordConfirmCheckButton.addTarget(self, action: #selector(passwordConfirmCheck), for: .touchUpInside)
    }
    
    //MARK: - 오토레이아웃 설정
    
    func setupUI() {
        view.addSubview(signUpLabel)
        view.addSubview(stackView)
        
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordCheckButton.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmCheckButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            // 회원가입 레이블
            signUpLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            signUpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            // 이메일 텍스트 필드
            emailTextField.leadingAnchor.constraint(equalTo: emailView.leadingAnchor, constant: 8),
            emailTextField.trailingAnchor.constraint(equalTo: emailView.trailingAnchor, constant: 8),
            emailTextField.centerYAnchor.constraint(equalTo: emailView.centerYAnchor),
            
            // 패스워드 텍스트 필드
            passwordTextField.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor, constant: 8),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor, constant: 8),
            passwordTextField.centerYAnchor.constraint(equalTo: passwordView.centerYAnchor),
            // 패스워드 텍스트 필드 뷰에 "표시" 버튼
            passwordCheckButton.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor, constant: -8),
            passwordCheckButton.topAnchor.constraint(equalTo: passwordView.topAnchor, constant: 15),
            passwordCheckButton.bottomAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: -15),
            
            // 패스워드 컨펌 텍스트 필드
            passwordConfirmTextField.leadingAnchor.constraint(equalTo: passwordConfirmView.leadingAnchor, constant: 8),
            passwordConfirmTextField.trailingAnchor.constraint(equalTo: passwordConfirmView.trailingAnchor, constant: 8),
            passwordConfirmTextField.centerYAnchor.constraint(equalTo: passwordConfirmView.centerYAnchor),
            
            // 패스워드 컨펌 텍스트 뷰에 "표시" 버튼
            passwordConfirmCheckButton.trailingAnchor.constraint(equalTo: passwordConfirmView.trailingAnchor, constant: -8),
            passwordConfirmCheckButton.topAnchor.constraint(equalTo: passwordConfirmView.topAnchor, constant: 15),
            passwordConfirmCheckButton.bottomAnchor.constraint(equalTo: passwordConfirmView.bottomAnchor, constant: -15),
            
            // 스택 뷰
            stackView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: viewHeight * 4 + 54),
        ])
    }
    
    
    @objc func passwordCheck() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        passwordCheckButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc func passwordConfirmCheck() {
        passwordConfirmTextField.isSecureTextEntry.toggle()
        let imageName = passwordConfirmTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        passwordConfirmCheckButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc func textFieldChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let confirmPassword = passwordConfirmTextField.text, !confirmPassword.isEmpty else {
            signUpButton.backgroundColor = .darkGray
            signUpButton.isEnabled = false
            return
        }
        signUpButton.backgroundColor = #colorLiteral(red: 0.8580306172, green: 0.1295066774, blue: 0.1757571995, alpha: 1)
        signUpButton.isEnabled = true
    }
    
    
    @objc func signUpButtonTapped() {
        let alert = UIAlertController(title: "회원가입" ,message: "입력하신 정보로 가입하시겠습니까?", preferredStyle: .alert)
        
        let success = UIAlertAction(title: "확인", style: .default) { action in
            print("확인 버튼이 눌림")
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default) { action in
            print("취소 버튼이 눌림")
        }
        
        alert.addAction(success)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}
