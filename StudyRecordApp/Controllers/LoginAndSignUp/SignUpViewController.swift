//
//  SignUpViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit
import PKHUD

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
    
    @IBAction private func passwordSecureButtonDidTapped(_ sender: Any) {
        guard let eyeFillImage = UIImage(systemName: "eye.fill"),
              let eyeSlashFillImage = UIImage(systemName: "eye.slash.fill") else { return }
        if isPasswordHidden {
            passwordSecureButton.setImage(eyeFillImage)
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordSecureButton.setImage(eyeSlashFillImage)
            passwordTextField.isSecureTextEntry = true
        }
        isPasswordHidden.toggle()
    }
    
    @IBAction private func passwordConfirmationSecureButtonDidTapped(_ sender: Any) {
        guard let eyeFillImage = UIImage(systemName: "eye.fill"),
              let eyeSlashFillImage = UIImage(systemName: "eye.slash.fill") else { return }
        if isPasswordConfirmationHidden {
            passwordConfirmationSecureButton.setImage(eyeFillImage)
            passwordConfirmationTextField.isSecureTextEntry = false
        } else {
            passwordConfirmationSecureButton.setImage(eyeSlashFillImage)
            passwordConfirmationTextField.isSecureTextEntry = true
        }
        isPasswordConfirmationHidden.toggle()
    }
    
    @IBAction private func signUpButtonDidTapped(_ sender: Any) {
        guard let mailAddressText = mailAddressTextField.text,
              let passwordText = passwordTextField.text,
              let passwordConfirmationText = passwordConfirmationTextField.text else { return }
        if passwordText != passwordConfirmationText {
            showAlert(title: "パスワードが一致しません")
            return
        }
        if passwordText.count < 6 {
            showAlert(title: "パスワードは６文字以上で入力してください")
            return
        }
        if mailAddressText == userUseCase.currentUser?.email ?? "" {
            showAlert(title: "このメールアドレスは既に登録されています")
            return
        }
        if mailAddressText.contains(" ") {
            showAlert(title: "メールアドレスに空白が含まれます")
            return
        }
        HUD.show(.progress)
        userUseCase.registerUser(email: mailAddressText,
                                 password: passwordText) { result in
            switch result {
                case .failure(let error):
                    self.flashHUD(.error) {
                        self.showAlert(title: "新規登録に失敗しました\(error.localizedDescription)")
                    }
                case .success(let user):
                    self.createUser(userId: user.uid, mailAddressText: mailAddressText)
            }
        }
    }
    
    private func createUser(userId: String, mailAddressText: String) {
        self.userUseCase.createUser(userId: userId,
                                    email: mailAddressText) { result in
            switch result {
                case .failure(let error):
                    self.flashHUD(.error) {
                        self.showAlert(title: "新規登録に失敗しました\(error.localizedDescription)")
                    }
                case .success:
                    self.flashHUD(.success) {
                        print("成功")
                    }
            }
        }
    }
    
    private func flashHUD(_ type: HUDContentType,
                          completion: @escaping () -> Void) {
        HUD.flash(type,
                  onView: nil,
                  delay: 0) { _ in
            completion()
        }
    }
    
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func changeSignUpButtonState(isEnabled: Bool) {
        signUpButton.isEnabled = isEnabled
        signUpButton.backgroundColor = isEnabled ? .black : .gray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        mailAddressTextField.keyboardType = .URL
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
