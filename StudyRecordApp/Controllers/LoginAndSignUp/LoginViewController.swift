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

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mailAddressTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordSecureButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordForgotButton: UIButton!
    
    weak var delegate: LoginVCDelegate?
    private var isPasswordHidden = true
    private var isKeyboardHidden = true
    private var userUseCase = UserUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGR()
        setupMailAddressTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupPasswordSecureButton()
        setupPasswordForgotButton()
        setupKeyboardObserver()
        
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
            showErrorAlert(title: "通信環境が良くありません")
            return
        }
        showHUD(.progress)
        userUseCase.login(email: email,
                          password: password) { result in
            switch result {
                case .failure(let title):
                    self.flashHUD(.error) {
                        self.showErrorAlert(title: title)
                    }
                case .success:
                    self.flashHUD(.success) {
                        print("成功")
                    }
            }
        }
    }
    
    @IBAction func passwordForgotButtonDidTapped(_ sender: Any) {
        let resetingPasswordVC = ResetingPasswordViewController.instantiate()
        present(resetingPasswordVC, animated: true, completion: nil)
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
    
    func setupMailAddressTextField() {
        mailAddressTextField.delegate = self
        mailAddressTextField.keyboardType = .URL
        mailAddressTextField.setUnderLine()
    }
    
    func setupPasswordTextField() {
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .newPassword
        passwordTextField.setUnderLine()
    }
    
    func setupLoginButton() {
        loginButton.layer.cornerRadius = 10
        changeLoginButtonState(isEnabled: false)
    }
    
    func setupPasswordSecureButton() {
        changePasswordSecureButtonImage(isSlash: false)
    }
    
    func setupPasswordForgotButton() {
        passwordForgotButton.layer.cornerRadius = 10
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
