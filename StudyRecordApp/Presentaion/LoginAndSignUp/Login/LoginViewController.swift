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
        userUseCase: RxUserUseCase(repository: RxUserRepository()),
        mailText: mailAddressTextField.rx.text.orEmpty.asDriver(),
        passwordText: passwordTextField.rx.text.orEmpty.asDriver(),
        loginButton: loginButton.rx.tap.asSignal(),
        passwordSecureButton: passwordSecureButton.rx.tap.asSignal(),
        passwordForgotButton: passwordForgotButton.rx.tap.asSignal()
    )
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        viewModel.inputs.viewDidLoad()

    }

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func setupBindings() {
        viewModel.outputs.passwordSecureButtonImage
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.passwordSecureButton.setImage($0, for: .normal)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .dismiss:
                    self.dismiss(animated: true)
                case .showErrorAlert(let title):
                    self.showErrorAlert(title: title)
                case .presentResetingPassword:
                    guard let resetingPasswordVC = UIStoryboard(name: "ResetingPassword", bundle: nil)
                        .instantiateInitialViewController() else { return }
                    self.present(resetingPasswordVC, animated: true)
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.shouldPasswordTextFieldSecure
            .drive(passwordTextField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)

        viewModel.outputs.stackViewTopConstant
            .drive(onNext: { [weak self] constant in
                guard let self = self else { return }
                UIView.animate(deadlineFromNow: 0, duration: 0.5) {
                    self.stackViewTopConstraint.constant += constant
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.isLoginButtonEnabled
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.loginButton.changeState(isEnabled: $0)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.inputs.keyboardWillShow()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.inputs.keyboardWillHide()
            })
            .disposed(by: disposeBag)
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

    func setupUI() {
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
        self.view.backgroundColor = .dynamicColor(light: .white,
                                                  dark: .secondarySystemBackground)
    }

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
        mailAddressLabel.text = L10n.mailAddress
        mailAddressLabel.textColor = .dynamicColor(light: .black, dark: .white)
    }

    func setupMailAddressTextField() {
        mailAddressTextField.delegate = self
        mailAddressTextField.keyboardType = .URL
    }

    func setupPasswordLabel() {
        passwordLabel.text = L10n.password
        passwordLabel.textColor = .dynamicColor(light: .black, dark: .white)
    }

    func setupPasswordTextField() {
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .newPassword
    }

    func setupMailAddressImage() {
        let envelopImage = UIImage(systemName: .envelope)
        mailAddressImage.image = envelopImage.setColor(.dynamicColor(light: .black, dark: .white))
    }

    func setupLoginButton() {
        loginButton.setTitle(L10n.login)
        loginButton.changeState(isEnabled: false)
    }

    func setupPasswordSecureButton() {
        passwordSecureButton.tintColor = .dynamicColor(light: .black, dark: .white)
    }

    func setupPasswordForgotLabel() {
        passwordForgotLabel.text = L10n.passwordForgot
        passwordForgotLabel.textColor = .dynamicColor(light: .black, dark: .white)
    }

    func setupPasswordForgotButton() {
        passwordForgotButton.setTitle(L10n.here)
    }

    func setupPasswordImage() {
        let lockImage = UIImage(systemName: .lock)
        passwordImage.image = lockImage.setColor(.dynamicColor(light: .black, dark: .white))
    }

}
