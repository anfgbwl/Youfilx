import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var loginCompletion: (() -> Void)?
    var signUpCompletion: (() -> Void)?
    
    // MARK: - 로고 타이틀
    private lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "youflix_logo") // 이미지 파일 이름
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    // MARK: - 이메일 텍스트 뷰
    private lazy var emailView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
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
        
        // Delegate를 설정하여 포커스 상태 변화 감지
        tf.delegate = self
        
        return tf
    }()
    
    // MARK: - 비밀번호 텍스트 뷰
    private lazy var passwordView: UIView = {
        let view = UIView()
        view.frame.size.height = 48
        view.backgroundColor = .darkGray
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
        tf.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: [.foregroundColor: UIColor.white])
        
        // Delegate를 설정하여 포커스 상태 변화 감지
        tf.delegate = self
        return tf
    }()
    
    // 패스워드에 "표시" 버튼
    private let passwordCheckButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName:"eye.fill"),for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - 로그인 버튼
    private let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.5568627715, blue: 0.5568627715, alpha: 1)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.isEnabled = false // 초기 비활성화

        return button
    }()
    
    // MARK: - 스택 뷰
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailView, passwordView, loginButton])
        stack.spacing = 18
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    // 회원가입 버튼
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        return button
    }()
    
    // 이메일 뷰와 패스워드 뷰, 로그인 버튼 높이 설정
    private let viewHeight: CGFloat = 48
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        signUpButton.addTarget(self, action: #selector(moveToSignUpViewController), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - 오토레이아웃 설정
    
    func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        view.addSubview(signUpButton)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordCheckButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            // 로고 이미지
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 250),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 이메일 텍스트 필드
            emailTextField.leadingAnchor.constraint(equalTo: emailView.leadingAnchor, constant: 8),
            emailTextField.trailingAnchor.constraint(equalTo: emailView.trailingAnchor, constant: 8),
            emailTextField.centerYAnchor.constraint(equalTo: emailView.centerYAnchor),
            // 패스워드 텍스트 필드
            passwordTextField.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor, constant: 8),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor, constant: 8),
            passwordTextField.centerYAnchor.constraint(equalTo: passwordView.centerYAnchor),
            // 패스워드 "표시" 버튼
            passwordCheckButton.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor, constant: -8),
            passwordCheckButton.topAnchor.constraint(equalTo: passwordView.topAnchor, constant: 15),
            passwordCheckButton.bottomAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: -15),
            // 스택 뷰
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: viewHeight * 3 + 36),
            // 회원가입 버튼
            signUpButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signUpButton.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }

    
    @objc func loginButtonTapped() {
        loginCompletion?()
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    
    @objc func moveToSignUpViewController() {
        print("회원가입 버튼 눌림")
        signUpCompletion?()
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
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
        
    
    //MARK: - Delegate 설정
    // 텍스트 필드 delegate 메서드 구현
    
    // 텍스트 필드가 포커스를 얻었을 때 호출되는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 텍스트 필드가 emailTextField일 경우 플레이스 홀더 텍스트를 지움
        if textField == emailTextField {
            textField.placeholder = nil
        }
        // 텍스트 필드가 passwordTextField일 경우 플레이스 홀더 텍스트를 지움
        if textField == passwordTextField {
            textField.placeholder = nil
        }
    }
    
    // 텍스트 필드가 포커스를 잃었을 때 호출되는 메서드
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트 필드가 emailTextField이고 내용이 없는 경우 플레이스 홀더 텍스트를 복원
        if textField == emailTextField && textField.text?.isEmpty ?? true {
            textField.placeholder = "이메일을 입력하세요."
        }
        // 텍스트 필드가 passwordTextField이고 내용이 없는 경우 플레이스 홀더 텍스트를 복원
        if textField == passwordTextField && textField.text?.isEmpty ?? true {
            textField.placeholder = "비밀번호를 입력하세요."
        }
    }
}
