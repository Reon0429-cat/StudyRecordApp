//
//  PasscodeSettingViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/01.
//

import UIKit
import LocalAuthentication

final class PasscodeSettingViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var passcodeSwitch: CustomSwitch!
    @IBOutlet private weak var biometricsButton: RadioButton!
    
    private let settingUseCase = SettingUseCase(
        repository: SettingRepository(
            dataStore: RealmSettingDataStore()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBiometricsButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupPasscodeSwitch()
        
    }
    
}

// MARK: - IBAction func
private extension PasscodeSettingViewController {
    
    @IBAction func passcodeSwitchValueDidChanged(_ sender: UISwitch) {
        self.settingUseCase.change(isPasscodeSetted: sender.isOn)
        if !self.settingUseCase.isPasscodeCreated && sender.isOn {
            self.present(PasscodeViewController.self,
                         modalPresentationStyle: .fullScreen) { vc in
                vc.passcodeMode = .create
            }
        }
    }
    
    @IBAction func biometricsButtonDidTapped(_ sender: Any) {
        let isBiometricsSetted = settingUseCase.setting.isBiometricsSetted
        biometricsButton.setImage(isFilled: !isBiometricsSetted)
        settingUseCase.update(isBiometricsSetted: !isBiometricsSetted)
    }
    
}

// MARK: - HalfModalPresenterDelegate
extension PasscodeSettingViewController: HalfModalPresenterDelegate {
    
    var halfModalContentHeight: CGFloat {
        return contentView.frame.height
    }
    
}

// MARK: - setup
private extension PasscodeSettingViewController {
    
    func setupPasscodeSwitch() {
        passcodeSwitch.isOn = settingUseCase.setting.isPasscodeSetted
    }
    
    func setupBiometricsButton() {
        biometricsButton.setTitle("FaceIDをオンにする")
        let isFilled = settingUseCase.setting.isBiometricsSetted
        biometricsButton.setImage(isFilled: isFilled)
    }
    
}
