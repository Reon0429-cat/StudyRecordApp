//
//  SignUpViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit

protocol SignUpVCDelegate: AnyObject {
    func rightSwipeDid()
}

final class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var mailAddressTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordSecureButton: UIButton!
    @IBOutlet private weak var passwordConfirmationTextField: UITextField!
    @IBOutlet private weak var passwordConfirmationSecureButton: UIButton!
    @IBOutlet private weak var signUpButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var signUpButton: UIButton!
    
    weak var delegate: SignUpVCDelegate?
    private var isPasswordHidden = true
    private var isPasswordConfirmationHidden = true
    private var isKeyboardHidden = true
    private var userUseCase = UserUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGR()
        setupMailAddressTextField()
        setupPasswordTextField()
        setupPasswordConfirmationTextField()
        setupSignUpButton()
        setupKeyboardObserver()
        changeSignUpButtonState(isEnabled: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mailAddressTextField.setUnderLine()
        passwordTextField.setUnderLine()
        passwordConfirmationTextField.setUnderLine()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: - IBAction func
private extension SignUpViewController {
    
    @IBAction func passwordSecureButtonDidTapped(_ sender: Any) {
        guard let eyeFillImage = UIImage(systemName: "eye.fill"),
              let eyeSlashFillImage = UIImage(systemName: "eye.slash.fill") else { return }
        let image = isPasswordHidden ? eyeFillImage : eyeSlashFillImage
        passwordSecureButton.setImage(image)
        passwordTextField.isSecureTextEntry.toggle()
        isPasswordHidden.toggle()
    }
    
    @IBAction func passwordConfirmationSecureButtonDidTapped(_ sender: Any) {
        guard let eyeFillImage = UIImage(systemName: "eye.fill"),
              let eyeSlashFillImage = UIImage(systemName: "eye.slash.fill") else { return }
        let image = isPasswordConfirmationHidden ? eyeFillImage : eyeSlashFillImage
        passwordConfirmationSecureButton.setImage(image)
        passwordConfirmationTextField.isSecureTextEntry.toggle()
        isPasswordConfirmationHidden.toggle()
    }
    
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        guard let mailAddressText = mailAddressTextField.text,
              let passwordText = passwordTextField.text,
              let passwordConfirmationText = passwordConfirmationTextField.text else { return }
        if CommunicationStatus().unstable() {
            showErrorAlert(title: "通信環境が良くありません")
            return
        }
        if passwordText != passwordConfirmationText {
            showErrorAlert(title: "パスワードが一致しません")
            return
        }
        showHUD(.progress)
        registerUser(email: mailAddressText, password: passwordText)
    }
    
}

// MARK: - func
private extension SignUpViewController {
    
    func registerUser(email: String, password: String) {
        userUseCase.registerUser(email: email,
                                 password: password) { result in
            switch result {
                case .failure(let message):
                    self.flashHUD(.error) {
                        self.showErrorAlert(title: message)
                    }
                case .success(let user):
                    self.createUser(userId: user.uid, mailAddressText: email)
            }
        }
    }
    
    func createUser(userId: String, mailAddressText: String) {
        userUseCase.createUser(userId: userId,
                               email: mailAddressText) { result in
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
    
    func changeSignUpButtonState(isEnabled: Bool) {
        signUpButton.isEnabled = isEnabled
        signUpButton.backgroundColor = isEnabled ? .black : .gray
    }
    
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let mailAddressText = mailAddressTextField.text,
              let passwordText = passwordTextField.text,
              let passwordConfirmationText = passwordConfirmationTextField.text else { return }
        let isEnabled = !mailAddressText.isEmpty && !passwordText.isEmpty && !passwordConfirmationText.isEmpty
        changeSignUpButtonState(isEnabled: isEnabled)
    }
    
}

// MARK: - setup
private extension SignUpViewController {
    
    func setupGR() {
        let rightSwipeGR = UISwipeGestureRecognizer(target: self,
                                                    action: #selector(rightSwipeDid))
        rightSwipeGR.direction = .right
        self.view.addGestureRecognizer(rightSwipeGR)
    }
    
    @objc
    func rightSwipeDid() {
        delegate?.rightSwipeDid()
    }
    
    func setupMailAddressTextField() {
        mailAddressTextField.delegate = self
        mailAddressTextField.keyboardType = .emailAddress
    }
    
    func setupPasswordTextField() {
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .newPassword
    }
    
    func setupPasswordConfirmationTextField() {
        passwordConfirmationTextField.delegate = self
        passwordConfirmationTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .newPassword
    }
    
    func setupSignUpButton() {
        signUpButton.layer.cornerRadius = 10
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
                self.stackView.spacing -= 15
                self.signUpButtonTopConstraint.constant -= 30
                self.view.layoutIfNeeded()
            }
        }
        isKeyboardHidden = false
    }
    
    @objc
    func keyboardWillHide() {
        if !isKeyboardHidden {
            UIView.animate(deadlineFromNow: 0, duration: 0.5) {
                self.stackView.spacing += 15
                self.signUpButtonTopConstraint.constant += 30
                self.view.layoutIfNeeded()
            }
        }
        isKeyboardHidden = true
    }
    
}
