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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSendButton()
        setupMailAddressTextField()
        
    }
    
    @IBAction private func sendButtonDidTapped(_ sender: Any) {
        
    }
    
    func setupSendButton() {
        sendButton.layer.cornerRadius = 10
    }
    
    func setupMailAddressTextField() {
        mailAddressTextField.setUnderLine()
    }
    
}
