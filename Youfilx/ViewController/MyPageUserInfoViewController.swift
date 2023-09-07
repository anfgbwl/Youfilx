import UIKit

class MyPageUserInfoViewController: UIViewController {

    // 사용자 정보
    var user: User = loadUserFromUserDefaults()!
    
    // MARK: - 프로필 사진
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75 // 원 모양의 프로필 이미지를 위한 값
        imageView.image = UIImage(named: "profile_placeholder.png") // 기본 이미지 설정
        return imageView
    }()
    
    // MARK: - 프로필 사진 변경 버튼
    private let changeProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 사진 변경", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(changeProfilePicture), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 닉네임
    private let nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 60
        tf.backgroundColor = .darkGray
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }()
    
    // MARK: - 이메일 레이블 (수정 불가능)
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .darkGray
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 6 // 라운드 처리를 위한 값을 설정
        label.layer.masksToBounds = true // 라운드 처리 적용
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - 비밀번호
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        tf.borderStyle = .roundedRect
        tf.frame.size.height = 60
        tf.backgroundColor = .darkGray
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = false
        tf.textContentType = .none
        return tf
    }()
    
    // MARK: - 비밀번호 확인
    private let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "비밀번호 확인", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        tf.borderStyle = .roundedRect
        tf.frame.size.height = 60
        tf.backgroundColor = .darkGray
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = false
        tf.textContentType = .none
        return tf
    }()
    
    // MARK: - 저장 버튼
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground

        
        title = "회원 정보 수정"

        
        // UI 요소를 뷰에 추가
        view.addSubview(profileImageView)
        view.addSubview(changeProfileButton)
        view.addSubview(nicknameTextField)
        view.addSubview(emailLabel)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(saveButton)
        
        // 오토레이아웃 설정
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        changeProfileButton.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            
            changeProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeProfileButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            
            nicknameTextField.topAnchor.constraint(equalTo: changeProfileButton.bottomAnchor, constant: 20),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            emailLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailLabel.heightAnchor.constraint(equalToConstant: 48),
            
            passwordTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            saveButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        // 사용자 정보를 텍스트 필드와 레이블에 설정
        nicknameTextField.text = user.nickname
        emailLabel.text = "  \(user.id)"
    }
    
    // MARK: - 프로필 사진 변경 액션
    @objc private func changeProfilePicture() {
        // 프로필 사진 변경 로직 구현
    }
    
    // MARK: - 저장 버튼 탭 액션
    @objc private func saveButtonTapped() {
        // 입력된 정보로 사용자 정보를 업데이트하고 UserDefaults에 저장
        if let newNickname = nicknameTextField.text, !newNickname.isEmpty {
            user.nickname = newNickname
        }
        
        if let newPassword = passwordTextField.text, !newPassword.isEmpty {
            user.password = newPassword
        }
        
        // 사용자 정보 업데이트
        saveUserToUserDefaults(user: user)
        
        // 성공적으로 업데이트되었다는 알림을 사용자에게 보여줄 수 있음
        showAlert(title: "성공", message: "사용자 정보가 업데이트되었습니다.")
    }
    
    // 경고창을 보여주는 메서드
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
