//
//  ResetingPasswordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/29.
//

import UIKit

final class ResetingPasswordViewController: UIViewController {
    
    @IBOutlet private weak var mailAddressTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    
    private var userUseCase = UserUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSendButton()
        setupMailAddressTextField()
        
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
        showHUD(.progress)
        sendPasswordResetMail(email: email)
    }
    
}

// MARK: - func
private extension ResetingPasswordViewController {
    
    func sendPasswordResetMail(email: String) {
        userUseCase.sendPasswordResetMail(email: email) { result in
            switch result {
                case .failure(let title):
                    self.flashHUD(.error) {
                        self.showErrorAlert(title: title)
                    }
                case .success:
                    self.flashHUD(.success) {
                        self.dismiss(animated: true, completion: nil)
                    }
            }
        }
    }
    
    func changeSendButtonState(isEnabled: Bool) {
        sendButton.isEnabled = isEnabled
        sendButton.backgroundColor = isEnabled ? .black : .gray
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
        changeSendButtonState(isEnabled: isEnabled)
    }
    
}

// MARK: - setup
private extension ResetingPasswordViewController {
    
    func setupSendButton() {
        sendButton.layer.cornerRadius = 10
        changeSendButtonState(isEnabled: false)
    }
    
    func setupMailAddressTextField() {
        mailAddressTextField.delegate = self
        mailAddressTextField.keyboardType = .emailAddress
        mailAddressTextField.setUnderLine()
    }
    
}
