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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGR()
        setupMailAddressTextField()
        setupPasswordTextField()
        setupPasswordConfirmationTextField()
        setupSignUpButton()
        setupKeyboardObserver()
        
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
        passwordTextField.keyboardType = .URL
    }
    
    func setupPasswordConfirmationTextField() {
        passwordConfirmationTextField.delegate = self
        passwordConfirmationTextField.isSecureTextEntry = true
        passwordConfirmationTextField.keyboardType = .URL
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
    
}
