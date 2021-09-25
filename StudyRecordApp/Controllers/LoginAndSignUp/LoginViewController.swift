//
//  LoginViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/25.
//

import UIKit
import RxSwift
import RxCocoa

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
    private lazy var viewModel: LoginViewModelType = LoginViewModel(
        input: (
            loginButtonEvent: loginButton.rx.tap,
            passwordForgotButtonEvent: passwordForgotButton.rx.tap,
            passwordSecureButtonEvent: passwordSecureButton.rx.tap,
            mailAddressTextFieldProperty: mailAddressTextField.rx.text.orEmpty,
            passwordTextFieldProperty: passwordTextField.rx.text.orEmpty
        )
    )
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
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
        viewModel.inputs.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: - func
private extension LoginViewController {
    
    func setupBindings() {
        viewModel.outputs.loginButtonIsEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.outputs.loginButtonIsEnabled
            .map { $0 ? UIColor.black : UIColor.gray }
            .drive(loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.outputs.passwordSecureButtonImageName
            .map { UIImage(systemName: $0) }
            .compactMap { $0 }
            .drive(onNext: passwordSecureButton.setImage)
            .disposed(by: disposeBag)
        
        viewModel.outputs.passwordIsSecured
            .drive(passwordTextField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)
        
        viewModel.outputs.event
            .drive(onNext: { event in
                switch event {
                    case .keyboardWillShow:
                        self.keyboardDidShowed()
                    case .keyboardWillHide:
                        self.keyboardDidHidden()
                    case .presentErrorAlert(let title):
                        self.showErrorAlert(title: title)
                    case .changeRootVCToTopVC:
                        self.changeRootVC(TopViewController.self)
                    case .presentResetingPasswordVC:
                        self.present(ResetingPasswordViewController.self)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func keyboardDidShowed() {
        UIView.animate(deadlineFromNow: 0, duration: 0.5) {
            self.stackViewTopConstraint.constant -= 100
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardDidHidden() {
        UIView.animate(deadlineFromNow: 0, duration: 0.5) {
            self.stackViewTopConstraint.constant += 100
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        passwordTextField.textContentType = .newPassword
    }
    
    func setupMailAddressImage() {
        guard let image = UIImage(systemName: "envelope") else { return }
        mailAddressImage.image = image.setColor(.dynamicColor(light: .black, dark: .white))
    }
    
    func setupLoginButton() {
        loginButton.setTitle(LocalizeKey.login.localizedString())
    }
    
    func setupPasswordSecureButton() {
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
        viewModel.inputs.notifiedKeyboardShowed()
    }
    
    @objc
    func keyboardWillHide() {
        viewModel.inputs.notifiedKeyboardHidden()
    }
    
}
