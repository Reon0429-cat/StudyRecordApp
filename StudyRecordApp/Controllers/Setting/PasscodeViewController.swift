//
//  PasscodeViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/12.
//

import UIKit

final class PasscodeViewController: UIViewController {
    
    @IBOutlet private weak var passcodeView: PasscodeView!
    
    private let indicator = Indicator(kinds: PKHUDIndicator())
    private let testPasscode = [1, 2, 3, 4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPasscodeView()
        
    }
    
}

// MARK: - PasscodeViewDelegate
extension PasscodeViewController: PasscodeViewDelegate {
    
    func validate(inputtedNumbers: [Int]) {
        if inputtedNumbers == testPasscode {
            indicator.flash(.success) {
                self.dismiss(animated: true)
            }
        } else {
            indicator.flash(.error) {
                self.passcodeView.failure()
            }
        }
    }
    
}

// MARK: - setup
private extension PasscodeViewController {
    
    func setupPasscodeView() {
        passcodeView.delegate = self
    }
    
}
