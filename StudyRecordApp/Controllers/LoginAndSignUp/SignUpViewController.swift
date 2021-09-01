//
//  SignUpViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit

protocol SignUpVCDelegate: AnyObject {
    func rightSwipeDid()
    func signUpDidSuccessed()
}

final class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var mailAddressTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordSecureButton: UIButton!
    @IBOutlet private weak var passwordConfirmationTextField: UITextField!
    @IBOutlet private weak var passwordConfirmationSecureButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var signUpButtonTopConstraint: NSLayoutConstraint!
    
    weak var delegate: SignUpVCDelegate?
    private var isPasswordHidden = true
    private var isPasswordConfirmationHidden = true
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
        setupPasswordConfirmationTextField()
        setupPasswordSecureButton()
        setupPasswordConfirmationSecureButton()
        setupSignUpButton()
        setupKeyboardObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mailAddressTextField.setUnderLine()
        passwordTextField.setUnderLine()
        passwordConfirmationTextField.setUnderLine()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: - IBAction func
private extension SignUpViewController {
    
    @IBAction func passwordSecureButtonDidTapped(_ sender: Any) {
        changePasswordSecureButtonImage(isSlash: isPasswordHidden)
        passwordTextField.isSecureTextEntry.toggle()
        isPasswordHidden.toggle()
    }
    
    @IBAction func passwordConfirmationSecureButtonDidTapped(_ sender: Any) {
        changePasswordConfirmationSecureButtonImage(isSlash: isPasswordConfirmationHidden)
        passwordConfirmationTextField.isSecureTextEntry.toggle()
        isPasswordConfirmationHidden.toggle()
    }
    
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        guard let email = mailAddressTextField.text,
              let password = passwordTextField.text,
              let passwordConfirmation = passwordConfirmationTextField.text else { return }
        if CommunicationStatus().unstable() {
            showErrorAlert(title: "通信環境が良くありません")
            return
        }
        if password != passwordConfirmation {
            showErrorAlert(title: "パスワードが一致しません")
            return
        }
        indicator.show(.progress)
        registerUser(email: email, password: password)
    }
    
}

// MARK: - func
private extension SignUpViewController {
    
    func registerUser(email: String, password: String) {
        userUseCase.registerUser(email: email,
                                 password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let title):
                    self.indicator.flash(.error) {
                        self.showErrorAlert(title: title)
                    }
                case .success(let user):
                    self.createUser(userId: user.id, mailAddressText: email)
            }
        }
    }
    
    func createUser(userId: String, mailAddressText: String) {
        userUseCase.createUser(userId: userId,
                               email: mailAddressText) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let title):
                    self.indicator.flash(.error) {
                        self.showErrorAlert(title: title)
                    }
                case .success:
                    self.indicator.flash(.success) {
                        self.delegate?.signUpDidSuccessed()
                    }
            }
        }
    }
    
    func changeSignUpButtonState(isEnabled: Bool) {
        signUpButton.isEnabled = isEnabled
        signUpButton.backgroundColor = isEnabled ? .black : .gray
    }
    
    func changePasswordSecureButtonImage(isSlash: Bool) {
        guard let eyeFillImage = UIImage(systemName: "eye.fill"),
              let eyeSlashFillImage = UIImage(systemName: "eye.slash.fill") else { return }
        let image = isSlash ? eyeSlashFillImage : eyeFillImage
        passwordSecureButton.setImage(image)
    }
    
    func changePasswordConfirmationSecureButtonImage(isSlash: Bool) {
        guard let eyeFillImage = UIImage(systemName: "eye.fill"),
              let eyeSlashFillImage = UIImage(systemName: "eye.slash.fill") else { return }
        let image = isSlash ? eyeSlashFillImage : eyeFillImage
        passwordConfirmationSecureButton.setImage(image)
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
    
    func setupPasswordSecureButton() {
        changePasswordSecureButtonImage(isSlash: false)
    }
    
    func setupPasswordConfirmationSecureButton() {
        changePasswordConfirmationSecureButtonImage(isSlash: false)
    }
    
    func setupSignUpButton() {
        signUpButton.layer.cornerRadius = 10
        changeSignUpButtonState(isEnabled: false)
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
                if self.view.frame.height < 600 {
                    self.stackView.spacing -= 25
                    self.signUpButtonTopConstraint.constant -= 40
                } else {
                    self.stackView.spacing -= 15
                    self.signUpButtonTopConstraint.constant -= 20
                }
                self.view.layoutIfNeeded()
            }
        }
        isKeyboardHidden = false
    }
    
    @objc
    func keyboardWillHide() {
        if !isKeyboardHidden {
            UIView.animate(deadlineFromNow: 0, duration: 0.5) {
                if self.view.frame.height < 600 {
                    self.stackView.spacing += 25
                    self.signUpButtonTopConstraint.constant += 40
                } else {
                    self.stackView.spacing += 15
                    self.signUpButtonTopConstraint.constant += 20
                }
                self.view.layoutIfNeeded()
            }
        }
        isKeyboardHidden = true
    }
    
}
