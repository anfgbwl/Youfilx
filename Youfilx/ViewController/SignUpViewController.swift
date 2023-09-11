import UIKit

class SignUpViewController: UIViewController {
    
    // 회원가입 성공 후에 로그인 화면으로 전달할 이메일과 비밀번호 프로퍼티
    var signUpEmail: String?
    var signUpPassword: String?
    
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
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .emailAddress
        tf.attributedPlaceholder = NSAttributedString(string: "이메일을 입력하세요", attributes: [.foregroundColor: UIColor.white])
        tf.addTarget(self, action: #selector(textFieldShouldEndEditing(_:)), for: .editingChanged)
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
    
    // 비밀번호 텍스트필드
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
        tf.clearsOnBeginEditing = false
        tf.textContentType = .none
        tf.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: [.foregroundColor: UIColor.white])
        tf.addTarget(self, action: #selector(textFieldShouldEndEditing(_:)), for: .editingChanged)
        return tf
    }()
    
    // 비밀번호 텍스트 필드 뷰에 "표시" 버튼
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
    
    // 비밀번호 확인 텍스트 필드
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
        tf.clearsOnBeginEditing = false
        tf.textContentType = .none
        tf.attributedPlaceholder = NSAttributedString(string: "확인 비밀번호를  입력하세요", attributes: [.foregroundColor: UIColor.white])
        tf.addTarget(self, action: #selector(textFieldShouldEndEditing(_:)), for: .editingChanged)
        return tf
    }()
    
    // 비밀번호 확인 텍스트 필드 뷰에 "표시" 버튼
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
        button.isEnabled = false
        
        return button
    }()
    
    // 이메일 텍스트 필드, 패스워드 필드, 패스워드 체크 필드, 회원가입 버튼 높이 설정
    private let viewHeight: CGFloat = 48
    
    // MARK: - 유효성 검사에 사용할 정규식
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    private let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 이메일 텍스트 필드와 비밀번호 텍스트 필드의 델리게이트 설정
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        
        setupUI()
        
        passwordCheckButton.addTarget(self, action: #selector(passwordCheck), for: .touchUpInside)
        passwordConfirmCheckButton.addTarget(self, action: #selector(passwordConfirmCheck), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 오토레이아웃 설정
    func setupUI() {
        // Navigation Bar
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = ""
        
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
    
    // MARK: - 회원가입 버튼 눌렀을 때 동작
    @objc func signUpButtonTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = passwordConfirmTextField.text
        else {
            return
        }
        
        // 이메일 중복 체크
        if isEmailAlreadyRegistered(email) {
            showAlert(title: "이메일 중복", message: "이미 가입된 이메일 주소입니다.")
            return
        }
        
        // 이메일과 비밀번호 유효성 검사
        if !isValidEmail(email) {
            showAlert(title: "이메일 형식 오류", message: "올바른 이메일 주소를 입력하세요.")
            return
        }
        
        if !isValidPassword(password) {
            showAlert(title: "비밀번호 형식 오류", message: "비밀번호는 최소 8자 이상이어야 하며, 영문과 숫자를 포함해야 합니다.")
            return
        }
        
        // 이메일과 비밀번호가 일치하는지 확인
        if password != confirmPassword {
            showAlert(title: "비밀번호 불일치", message: "비밀번호와 확인 비밀번호가 일치하지 않습니다.")
            return
        }
        
        // User 객체 생성
        let user = User(id: email, password: password, image: nil, watchHistory: nil, favoriteVideos: nil)
        
        // User 객체를 UserDefaults에 저장
        saveUserToUserDefaults(user: user)
        
        // 회원가입이 성공하면 회원가입 완료 얼럿을 표시
        let alert = UIAlertController(title: "회원가입 완료", message: "회원가입이 성공적으로 완료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            // 확인을 누르면 현재 뷰 컨트롤러를 스택에서 제거하여 이전 화면으로 복귀
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 정규식 유효성 검사
    private func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    // MARK: - 이메일 중복 체크 메서드
    private func isEmailAlreadyRegistered(_ email: String) -> Bool {
        // UserDefaults에서 User 객체를 로드
        if let user = loadUserFromUserDefaults() {
            // 이미 가입된 이메일 주소가 있는지 확인
            return user.id == email
        }
        return false
    }
    
    // MARK: - 얼럿창 표시 메서드
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - 텍스트필드 델리게이트
extension SignUpViewController: UITextFieldDelegate {
    
    // Return 키를 눌렀을 때 다음 텍스트 필드로 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordConfirmTextField.becomeFirstResponder()
        } else if textField == passwordConfirmTextField {
            textField.resignFirstResponder() // 키보드 숨김
        }
        return true
    }
    
    // 텍스트 필드의 입력이 종료될 때 호출
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // 입력값의 유효성을 검사하고 회원가입 버튼 활성화
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           let confirmPassword = passwordConfirmTextField.text {
            if !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty {
                signUpButton.backgroundColor = #colorLiteral(red: 0.8580306172, green: 0.1295066774, blue: 0.1757571995, alpha: 1)
                signUpButton.isEnabled = true
            } else {
                signUpButton.backgroundColor = .darkGray
                signUpButton.isEnabled = false
            }
        }
        return true
    }
}
