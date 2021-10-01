//
//  PasscodeViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/12.
//

import UIKit
import AudioToolbox

enum PasscodeMode {
    case certification
    case create
    case change
    case changeCertification
    
    var title: String {
        switch self {
            case .certification:
                return LocalizeKey.certification.localizedString()
            case .create:
                return LocalizeKey.create.localizedString()
            case .change:
                return LocalizeKey.change.localizedString()
            case .changeCertification:
                return LocalizeKey.certification.localizedString()
        }
    }
} 

final class PasscodeViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var passcodeView: PasscodeView!
    @IBOutlet private weak var changePasscodeButton: UIButton!
    
    private let indicator = Indicator(kinds: PKHUDIndicator())
    private var settingUseCase = SettingUseCase(
        repository: SettingRepository(
            dataStore: RealmSettingDataStore()
        )
    )
    var passcodeMode: PasscodeMode = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupSubCustomNavigationBar()
        setupPasscodeView()
        
        if settingUseCase.setting.isBiometricsSetted && passcodeMode != .create {
            BiometricsManager().canUseBiometrics { result in
                switch result {
                    case .success:
                        BiometricsManager().authenticate { result in
                            switch result {
                                case .success(let isSuccess):
                                    if isSuccess {
                                        // 成功
                                    } else {
                                        // 失敗
                                    }
                                    break
                                case .failure(let title):
                                    self.showErrorAlert(title: title)
                            }
                        }
                    case .failure(let title):
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.showErrorAlert(title: title) {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        passcodeView.clearAll()
        
    }
    
}

// MARK: - IBAction func
private extension PasscodeViewController {
    
    @IBAction func changePasscodeButtonDidTapped(_ sender: Any) {
        present(PasscodeViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.passcodeMode = .changeCertification
        }
    }
    
}

// MARK: - func
private extension PasscodeViewController {
    
    func validateCertification(inputState: PasscodeInputState) {
        switch inputState {
            case .first(let oncePasscode):
                if settingUseCase.isSame(passcode: oncePasscode) {
                    indicator.flash(.success) {
                        self.changeRootVC(TopViewController.self)
                    }
                } else {
                    setVibration()
                    indicator.flash(.error) {
                        self.passcodeView.changeInputLabelText("")
                    }
                }
            case .confirmation(_, let twicePasscode):
                if settingUseCase.isSame(passcode: twicePasscode) {
                    indicator.flash(.success) {
                        self.changeRootVC(TopViewController.self)
                    }
                } else {
                    setVibration()
                    indicator.flash(.error) {
                        self.passcodeView.changeInputLabelText("")
                    }
                }
        }
        
    }
    
    func validateCreate(inputState: PasscodeInputState) {
        switch inputState {
            case .first:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.passcodeView.changeInputLabelText(LocalizeKey.oneTimeLeft.localizedString())
                }
            case .confirmation(let oncePasscode, let twicePasscode):
                if oncePasscode == twicePasscode {
                    indicator.flash(.success) {
                        self.settingUseCase.create(passcode: oncePasscode)
                        self.dismiss(animated: true)
                    }
                } else {
                    setVibration()
                    showErrorAlert(title: LocalizeKey.passwordsDoNotMatch.localizedString())
                    passcodeView.changeInputLabelText(LocalizeKey.twoTimeLeft.localizedString())
                }
        }
    }
    
    func validateChange(inputState: PasscodeInputState) {
        switch inputState {
            case .first:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.passcodeView.changeInputLabelText(LocalizeKey.oneTimeLeft.localizedString())
                }
            case .confirmation(let oncePasscode, let twicePasscode):
                if oncePasscode == twicePasscode {
                    indicator.flash(.success) {
                        self.settingUseCase.update(passcode: oncePasscode)
                        self.changeRootVC(TopViewController.self)
                    }
                } else {
                    setVibration()
                    showErrorAlert(title: LocalizeKey.passwordsDoNotMatch.localizedString())
                    passcodeView.changeInputLabelText(LocalizeKey.pleaseEnterANewPasscode.localizedString())
                }
        }
    }
    
    func validateChangeCertification(inputState: PasscodeInputState) {
        switch inputState {
            case .first(let oncePasscode):
                if settingUseCase.isSame(passcode: oncePasscode) {
                    indicator.flash(.success) {
                        self.present(PasscodeViewController.self,
                                     modalPresentationStyle: .fullScreen) { vc in
                            vc.passcodeMode = .change
                        }
                    }
                } else {
                    setVibration()
                    indicator.flash(.error) {
                        self.passcodeView.changeInputLabelText(LocalizeKey.pleaseEnterYourCurrentPasscode.localizedString())
                    }
                }
            case .confirmation(_, let twicePasscode):
                if settingUseCase.isSame(passcode: twicePasscode) {
                    indicator.flash(.success) {
                        self.present(PasscodeViewController.self,
                                     modalPresentationStyle: .fullScreen) { vc in
                            vc.passcodeMode = .change
                        }
                    }
                } else {
                    setVibration()
                    indicator.flash(.error) {
                        self.passcodeView.changeInputLabelText(LocalizeKey.pleaseEnterYourCurrentPasscode.localizedString())
                    }
                }
        }
    }
    
    func setVibration() {
        AudioServicesPlaySystemSound(1102)
    }
    
}

// MARK: - PasscodeViewDelegate
extension PasscodeViewController: PasscodeViewDelegate {
    
    func input(inputState: PasscodeInputState) {
        switch passcodeMode {
            case .certification:
                validateCertification(inputState: inputState)
            case .create:
                validateCreate(inputState: inputState)
            case .change:
                validateChange(inputState: inputState)
            case .changeCertification:
                validateChangeCertification(inputState: inputState)
        }
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension PasscodeViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() { }
    
    func dismissButtonDidTapped() {
        switch passcodeMode {
            case .certification:
                settingUseCase.change(isPasscodeSetted: true)
            case .create:
                settingUseCase.change(isPasscodeSetted: false)
            case .change:
                settingUseCase.change(isPasscodeSetted: true)
            case .changeCertification:
                settingUseCase.change(isPasscodeSetted: true)
        }
        dismiss(animated: true)
    }
    
    var navTitle: String {
        return passcodeMode.title
    }
    
}

// MARK: - setup
private extension PasscodeViewController {
    
    func setupPasscodeView() {
        passcodeView.delegate = self
    }
    
    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isHidden: true)
    }
    
    func setup() {
        changePasscodeButton.setTitle(LocalizeKey.changePasscode.localizedString())
        switch passcodeMode {
            case .certification:
                passcodeView.changeInputLabelText("")
                subCustomNavigationBar.dismissButton(isHidden: true)
                changePasscodeButton.isHidden = false
            case .create:
                passcodeView.changeInputLabelText(LocalizeKey.twoTimeLeft.localizedString())
                
                subCustomNavigationBar.dismissButton(isHidden: false)
                changePasscodeButton.isHidden = true
            case .change:
                passcodeView.changeInputLabelText(LocalizeKey.pleaseEnterANewPasscode.localizedString())
                subCustomNavigationBar.dismissButton(isHidden: false)
                changePasscodeButton.isHidden = true
            case .changeCertification:
                passcodeView.changeInputLabelText(LocalizeKey.pleaseEnterYourCurrentPasscode.localizedString())
                subCustomNavigationBar.dismissButton(isHidden: false)
                changePasscodeButton.isHidden = true
        }
    }
    
}
