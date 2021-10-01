//
//  PasscodeSettingViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/01.
//

import UIKit

final class PasscodeSettingViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var passcodeSwitch: CustomSwitch!
    @IBOutlet private weak var biometricsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
}

// MARK: - HalfModalPresenterDelegate
extension PasscodeSettingViewController: HalfModalPresenterDelegate {
    
    var halfModalContentHeight: CGFloat {
        return contentView.frame.height
    }
    
}
