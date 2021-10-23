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
            case .certification: return L10n.certification
            case .create: return L10n.create
            case .change: return L10n.change
            case .changeCertification: return L10n.certification
        }
    }
} 

final class PasscodeViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var passcodeView: PasscodeView!
    @IBOutlet private weak var changePasscodeButton: UIButton!
    
    private let indicator = Indicator(kinds: PKHUDIndicator())
    private let settingUseCase = SettingUseCase(
        repository: SettingRepository(
            dataStore: RealmSettingDataStore()
        )
    )
    private var shouldPresentBiometrics: Bool {
        settingUseCase.setting.isBiometricsSetted
        && passcodeMode == .certification
    }
    var passcodeMode: PasscodeMode = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupSubCustomNavigationBar()
        setupPasscodeView()
        if shouldPresentBiometrics {
            presentBiometrics()
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
                    self.passcodeView.changeInputLabelText(L10n.oneTimeLeft)
                }
            case .confirmation(let oncePasscode, let twicePasscode):
                if oncePasscode == twicePasscode {
                    indicator.flash(.success) {
                        self.settingUseCase.create(passcode: oncePasscode)
                        self.dismiss(animated: true)
                    }
                } else {
                    setVibration()
                    showErrorAlert(title: L10n.passwordsDoNotMatch)
                    passcodeView.changeInputLabelText(L10n.twoTimeLeft)
                }
        }
    }
    
    func validateChange(inputState: PasscodeInputState) {
        switch inputState {
            case .first:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.passcodeView.changeInputLabelText(L10n.oneTimeLeft)
                }
            case .confirmation(let oncePasscode, let twicePasscode):
                if oncePasscode == twicePasscode {
                    indicator.flash(.success) {
                        self.settingUseCase.update(passcode: oncePasscode)
                        self.changeRootVC(TopViewController.self)
                    }
                } else {
                    setVibration()
                    showErrorAlert(title: L10n.passwordsDoNotMatch)
                    passcodeView.changeInputLabelText(L10n.pleaseEnterANewPasscode)
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
                        self.passcodeView.changeInputLabelText(L10n.pleaseEnterYourCurrentPasscode)
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
                        self.passcodeView.changeInputLabelText(L10n.pleaseEnterYourCurrentPasscode)
                    }
                }
        }
    }
    
    func setVibration() {
        AudioServicesPlaySystemSound(1102)
    }
    
    func presentBiometrics() {
        BiometricsManager().canUseBiometrics { result in
            switch result {
                case .success:
                    performBiometrics()
                case .failure:
                    DispatchQueue.main.async {
                        self.presentCanNotAllowBiometricsAlert()
                    }
            }
        }
    }
    
    func presentCanNotAllowBiometricsAlert() {
        let title = L10n.pleaseAllowBiometrics
        let message = L10n.turnOffBiometricsFromThisApp
        let alert = Alert.create(title: title,
                                 message: message)
            .addAction(title: L10n.close,
                       style: .destructive)
            .addAction(title: L10n.allow) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        present(alert, animated: true)
    }
    
    func performBiometrics() {
        BiometricsManager().authenticate { result in
            switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.changeRootVC(TopViewController.self)
                    }
                case .failure(let title):
                    DispatchQueue.main.async {
                        self.showErrorAlert(title: title)
                    }
            }
        }
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
        changePasscodeButton.setTitle(L10n.changePasscode)
        switch passcodeMode {
            case .certification:
                passcodeView.changeInputLabelText("")
                subCustomNavigationBar.dismissButton(isHidden: true)
                changePasscodeButton.isHidden = false
            case .create:
                passcodeView.changeInputLabelText(L10n.twoTimeLeft)
                
                subCustomNavigationBar.dismissButton(isHidden: false)
                changePasscodeButton.isHidden = true
            case .change:
                passcodeView.changeInputLabelText(L10n.pleaseEnterANewPasscode)
                subCustomNavigationBar.dismissButton(isHidden: false)
                changePasscodeButton.isHidden = true
            case .changeCertification:
                passcodeView.changeInputLabelText(L10n.pleaseEnterYourCurrentPasscode)
                subCustomNavigationBar.dismissButton(isHidden: false)
                changePasscodeButton.isHidden = true
        }
    }
    
}
