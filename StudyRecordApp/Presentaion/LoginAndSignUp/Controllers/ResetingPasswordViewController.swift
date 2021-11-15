//
//  ResetingPasswordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/29.
//

import UIKit

final class ResetingPasswordViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mailAddressImage: UIImageView!
    @IBOutlet private weak var mailAddressLabel: UILabel!
    @IBOutlet private weak var mailAddressTextField: CustomTextField!
    @IBOutlet private weak var sendButton: CustomButton!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var stackViewTopConstraint: NSLayoutConstraint!

    private let userUseCase = UserUseCase(
        repository: UserRepository()
    )
    private var isKeyboardHidden = true
    private let indicator = Indicator(kinds: PKHUDIndicator())

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitleLabel()
        setupMailAddressLabel()
        setupMailAddressImage()
        setupDetailLabel()
        setupMailAddressTextField()
        setupKeyboardObserver()
        setupSendButton()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

// MARK: - IBAction func
private extension ResetingPasswordViewController {

    @IBAction func sendButtonDidTapped(_ sender: Any) {
        guard let email = mailAddressTextField.text else { return }
        indicator.show(.progress)
        sendPasswordResetMail(email: email)
    }

}

// MARK: - func
private extension ResetingPasswordViewController {

    func sendPasswordResetMail(email: String) {
        userUseCase.sendPasswordResetMail(email: email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let title):
                self.indicator.flash(.error) {
                    self.showErrorAlert(title: title)
                }
            case .success:
                self.indicator.flash(.success) {
                    self.dismiss(animated: true)
                }
            }
        }
    }

}

// MARK: - UITextFieldDelegate
extension ResetingPasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let emailText = mailAddressTextField.text else { return }
        let isEnabled = !emailText.isEmpty
        sendButton.changeState(isEnabled: isEnabled)
    }

}

// MARK: - setup
private extension ResetingPasswordViewController {

    func setupSendButton() {
        sendButton.changeState(isEnabled: false)
        sendButton.setTitle(L10n.largeSend)
    }

    func setupMailAddressTextField() {
        mailAddressTextField.delegate = self
        mailAddressTextField.keyboardType = .emailAddress
    }

    func setupTitleLabel() {
        titleLabel.text = L10n.passwordForgotTitle
    }

    func setupMailAddressLabel() {
        mailAddressLabel.text = L10n.mailAddress
    }

    func setupMailAddressImage() {
        let envelopImage = UIImage(systemName: .envelope)
        mailAddressImage.image = envelopImage.setColor(.dynamicColor(light: .black, dark: .white))
    }

    func setupDetailLabel() {
        detailLabel.text = L10n.passwordForgotDetail
    }

    func setupKeyboardObserver() {
        if self.view.frame.height < 800 {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillShow),
                                                   name: UIResponder.keyboardWillShowNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillHide),
                                                   name: UIResponder.keyboardWillHideNotification,
                                                   object: nil)
        }
    }

    @objc
    func keyboardWillShow() {
        if isKeyboardHidden {
            UIView.animate(deadlineFromNow: 0, duration: 0.5) {
                self.stackViewTopConstraint.constant -= 30
                self.view.layoutIfNeeded()
            }
        }
        isKeyboardHidden = false
    }

    @objc
    func keyboardWillHide() {
        if !isKeyboardHidden {
            UIView.animate(deadlineFromNow: 0, duration: 0.5) {
                self.stackViewTopConstraint.constant += 30
                self.view.layoutIfNeeded()
            }
        }
        isKeyboardHidden = true
    }

}
