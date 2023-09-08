import UIKit

class MyPageUserInfoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

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
        label.textAlignment = .left // 텍스트 왼쪽 정렬
        label.layer.cornerRadius = 5 // 라운드 처리를 위한 값을 설정
        label.layer.masksToBounds = true // 라운드 처리 적용

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
    
    // 비밀번호 보이기/숨기기 버튼
    private lazy var passwordVisibilityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .white
        button.addTarget(self, action: #selector(passwordVisibilityButtonTapped), for: .touchUpInside)
        return button
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
    
    // 비밀번호 확인 보이기/숨기기 버튼
    private lazy var confirmPasswordVisibilityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .white
        button.addTarget(self, action: #selector(confirmPasswordVisibilityButtonTapped), for: .touchUpInside)
        return button
    }()

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
    

    // MARK: - 유효성 검사에 사용할 정규식
    private let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    private let nicknameRegex = "^[가-힣A-Za-z]{2,8}$" // 닉네임은 2~8자 사이의 한글과 영문 대소문자만 허용
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()

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
        if let loadedUser = loadUserFromUserDefaults() {
            self.user = loadedUser
            
            if let imageData = user.image, let profileImage = UIImage(data: imageData) {
                self.profileImageView.image = profileImage
            } else {
                // 이미지가 nil이면 placeholder 이미지를 설정
                self.profileImageView.image = UIImage(named: "profile_placeholder.png")
            }
        }
    }


    // MARK: - UI
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
        
        passwordTextField.rightView = passwordVisibilityButton
        passwordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = confirmPasswordVisibilityButton
        confirmPasswordTextField.rightViewMode = .always
        
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
            
            emailLabel.topAnchor.constraint(equalTo: changeProfileButton.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailLabel.heightAnchor.constraint(equalToConstant: 48),
            
            nicknameTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 20),
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
        nicknameTextField.text = "\(user.nickname)"
        emailLabel.text = "  \(user.id)"
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground


    // MARK: - 프로필 사진 변경 액션
    @objc private func changeProfilePicture() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // 이미지 라이브러리에서 선택하도록 설정
        imagePicker.allowsEditing = true

        let alertController = UIAlertController(title: "프로필 사진 변경", message: "프로필 사진을 변경하거나 삭제할 수 있습니다.", preferredStyle: .actionSheet)

        let changeAction = UIAlertAction(title: "프로필 사진 변경", style: .default) { [weak self] _ in
            self?.present(imagePicker, animated: true, completion: nil)
        }

        let deleteAction = UIAlertAction(title: "프로필 사진 삭제", style: .destructive) { [weak self] _ in
            // 프로필 이미지를 삭제하려면 user.image를 nil로 설정
            self?.user.image = nil

            // UserDefaults에도 업데이트
            self?.updateUserInUserDefaults(self!.user)

            // 이미지 뷰에 기본 이미지를 설정하거나 원하는 작업을 수행
            self?.profileImageView.image = UIImage(named: "profile_placeholder.png")
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(changeAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    
    @objc private func saveButtonTapped() {
        // 닉네임 값을 가져옴
        guard let newNickname = nicknameTextField.text, !newNickname.isEmpty else {
            showAlert(title: "오류", message: "닉네임을 입력하세요.")
            return
        }
        
        // 입력된 닉네임이 유효한지 검사
        guard isValidNickname(newNickname) else {
            showAlert(title: "오류", message: "닉네임은 2~8자 사이의 한글 혹은 영문이어야 합니다.")
            return
        }
        
        // 비밀번호와 비밀번호 확인 값을 가져옴
        let newPassword = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        
        // 입력된 정보로 사용자 정보를 업데이트하고 UserDefaults에 저장
        user.nickname = newNickname
        
        // 비밀번호와 비밀번호 확인이 모두 비어있지 않으면 비밀번호를 업데이트
        if !newPassword.isEmpty || !confirmPassword.isEmpty {
            // 비밀번호와 비밀번호 확인이 일치하는지 확인합니다.
            if newPassword != confirmPassword {
                showAlert(title: "오류", message: "비밀번호와 비밀번호 확인이 일치하지 않습니다.")
                return
            }
            
            // 입력된 비밀번호가 유효한지 검사
            guard isValidPassword(newPassword) else {
                showAlert(title: "오류", message: "비밀번호는 8자 이상의 영문 대소문자와 숫자 조합이어야 합니다.")
                return
            }
        
            // 비밀번호를 업데이트
        
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
        updateUserInUserDefaults(user)
        
        // 성공적으로 업데이트되었다는 알림을 사용자에게 출력
        showAlert(title: "성공", message: "사용자 정보가 업데이트되었습니다.")
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true) // 저장 버튼 클릭 시 뒤로가기 (미작동)
        }
    }
    
    // MARK: - 비밀번호 보이기/숨기기 액션
    @objc private func passwordVisibilityButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        passwordVisibilityButton.isSelected.toggle()
    }

    @objc private func confirmPasswordVisibilityButtonTapped() {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        confirmPasswordVisibilityButton.isSelected.toggle()
    }
    
    // 사용자 정보를 UserDefaults에 저장하는 메서드
    private func updateUserInUserDefaults(_ user: User) {
        let userDefaults = UserDefaults.standard
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            userDefaults.set(userData, forKey: "user")
        } catch {
            print("사용자 정보를 저장하는데 실패했습니다.")
        }
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    private func isValidNickname(_ nickname: String) -> Bool {
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return nicknameTest.evaluate(with: nickname)
    }
    
    // 경고창을 보여주는 메서드
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // 선택한 이미지를 프로필 이미지뷰에 설정
            profileImageView.image = selectedImage

            // 이미지를 Data로 변환하여 UserDefaults에 저장
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                user.image = imageData
                updateUserInUserDefaults(user)
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }


    

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


