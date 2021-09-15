//
//  LoginViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/25.
//

import UIKit

protocol LoginVCDelegate: AnyObject {
    func leftSwipeDid()
}

// MARK: - ToDo ユーザー削除機能実装する
// MARK: - ToDo ゲストユーザー機能を実装する

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mailAddressImage: UIImageView!
    @IBOutlet private weak var mailAddressLabel: UILabel!
    @IBOutlet private weak var mailAddressTextField: CustomTextField!
    @IBOutlet private weak var passwordImage: UIImageView!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var passwordSecureButton: UIButton!
    @IBOutlet private weak var loginButton: CustomButton!
    @IBOutlet private weak var passwordForgotButton: CustomButton!
    @IBOutlet private weak var passwordForgotLabel: UILabel!
    
    weak var delegate: LoginVCDelegate?
    private var isPasswordHidden = true
    private var isKeyboardHidden = true
    private var userUseCase = UserUseCase(
        repository: UserRepository(
            dataStore: FirebaseUserDataStore()
        )
    )
    private let indicator = Indicator(kinds: PKHUDIndicator())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGR()
        setupMailAddressTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupPasswordSecureButton()
        setupMailAddressImage()
        setupPasswordImage()
        setupPasswordLabel()
        setupMailAddressLabel()
        setupPasswordForgotLabel()
        setupPasswordForgotButton()
        setupKeyboardObserver()
        self.view.backgroundColor = .dynamicColor(light: .white,
                                                  dark: .secondarySystemBackground)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: - IBAction func
private extension LoginViewController {
    
    @IBAction func passwordSecureButtonDidTapped(_ sender: Any) {
        changePasswordSecureButtonImage(isSlash: isPasswordHidden)
        passwordTextField.isSecureTextEntry.toggle()
        isPasswordHidden.toggle()
    }
    
    @IBAction func loginButtonDidTapped(_ sender: Any) {
        guard let email = mailAddressTextField.text,
              let password = passwordTextField.text else { return }
        if CommunicationStatus().unstable() {
            showErrorAlert(title: LocalizeKey.communicationEnvironmentIsNotGood.localizedString())
            return
        }
        indicator.show(.progress)
        userUseCase.login(email: email,
                          password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let title):
                    self.indicator.flash(.error) {
                        self.showErrorAlert(title: title)
                    }
                case .success:
                    self.indicator.flash(.success) {
                        self.changeRootVC(TopViewController.self)
                    }
            }
        }
    }
    
    @IBAction func passwordForgotButtonDidTapped(_ sender: Any) {
        present(ResetingPasswordViewController.self)
    }
    
}

// MARK: - func
private extension LoginViewController {
    
    func changeLoginButtonState(isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
        loginButton.backgroundColor = isEnabled ? .black : .gray
    }
    
    func changePasswordSecureButtonImage(isSlash: Bool) {
        guard let eyeFillImage = UIImage(systemName: "eye.fill"),
              let eyeSlashFillImage = UIImage(systemName: "eye.slash.fill") else { return }
        let image = isSlash ? eyeSlashFillImage : eyeFillImage
        passwordSecureButton.setImage(image)
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let mailAddressText = mailAddressTextField.text,
              let passwordText = passwordTextField.text else { return }
        let isEnabled = !mailAddressText.isEmpty && !passwordText.isEmpty
        changeLoginButtonState(isEnabled: isEnabled)
    }
    
}

// MARK: - setup
private extension LoginViewController {
    
    func setupGR() {
        let leftSwipeGR = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(leftSwipeDid))
        leftSwipeGR.direction = .left
        self.view.addGestureRecognizer(leftSwipeGR)
    }
    
    @objc
    func leftSwipeDid() {
        delegate?.leftSwipeDid()
    }
    
    func setupMailAddressLabel() {
        mailAddressLabel.text = LocalizeKey.mailAddress.localizedString()
        mailAddressLabel.textColor = .dynamicColor(light: .black, dark: .white)
    }
    
    func setupMailAddressTextField() {
        mailAddressTextField.delegate = self
        mailAddressTextField.keyboardType = .URL
    }
    
    func setupPasswordLabel() {
        passwordLabel.text = LocalizeKey.password.localizedString()
        passwordLabel.textColor = .dynamicColor(light: .black, dark: .white)
    }
    
    func setupPasswordTextField() {
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .newPassword
    }
    
    func setupMailAddressImage() {
        guard let image = UIImage(systemName: "envelope") else { return }
        mailAddressImage.image = image.setColor(.dynamicColor(light: .black, dark: .white))
    }
    
    func setupLoginButton() {
        loginButton.setTitle(LocalizeKey.login.localizedString())
        changeLoginButtonState(isEnabled: false)
    }
    
    func setupPasswordSecureButton() {
        changePasswordSecureButtonImage(isSlash: false)
        passwordSecureButton.tintColor = .dynamicColor(light: .black, dark: .white)
    }
    
    func setupPasswordForgotLabel() {
        passwordForgotLabel.text = LocalizeKey.passwordForgot.localizedString()
        passwordForgotLabel.textColor = .dynamicColor(light: .black, dark: .white)
    }
    
    func setupPasswordForgotButton() {
        passwordForgotButton.setTitle(LocalizeKey.here.localizedString())
    }
    
    func setupPasswordImage() {
        guard let image = UIImage(systemName: "lock") else { return }
        passwordImage.image = image.setColor(.dynamicColor(light: .black, dark: .white))
    }
    
    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    func keyboardWillShow() {
        if isKeyboardHidden {
            UIView.animate(deadlineFromNow: 0, duration: 0.5) {
                self.stackViewTopConstraint.constant -= 100
                self.view.layoutIfNeeded()
            }
        }
        isKeyboardHidden = false
    }
    
    @objc
    func keyboardWillHide() {
        if !isKeyboardHidden {
            UIView.animate(deadlineFromNow: 0, duration: 0.5) {
                self.stackViewTopConstraint.constant += 100
                self.view.layoutIfNeeded()
            }
        }
        isKeyboardHidden = true
    }
    
}
