//
//  PasscodeViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/12.
//

import UIKit

enum PasscodeMode {
    case authentication
    case create
    case change
    case changeAuthentication
    
    var title: String {
        switch self {
            case .authentication: return "認証"
            case .create: return "作成"
            case .change: return "変更"
            case .changeAuthentication: return "認証"
        }
    }
}

// MARK: - ToDo パスコード, アニメーション, バイブレーション

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
        
    }
    
}

// MARK: - IBAction func
private extension PasscodeViewController {
    
    @IBAction func changePasscodeButtonDidTapped(_ sender: Any) {
        present(PasscodeViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.passcodeMode = .changeAuthentication
        }
    }
    
}

// MARK: - func
private extension PasscodeViewController {
    
    func validateAuthentication(inputState: PasscodeInputState) {
        switch inputState {
            case .first(let oncePasscode):
                if settingUseCase.isSame(passcode: oncePasscode) {
                    indicator.flash(.success) {
                        self.changeRootVC(TopViewController.self)
                    }
                } else {
                    // バイブレーション
                    indicator.flash(.error) {
                        self.passcodeView.resetLabel(inputCountLabelText: "")
                    }
                }
            case .confirmation(_, let twicePasscode):
                if settingUseCase.isSame(passcode: twicePasscode) {
                    indicator.flash(.success) {
                        self.changeRootVC(TopViewController.self)
                    }
                } else {
                    // バイブレーション
                    indicator.flash(.error) {
                        self.passcodeView.resetLabel(inputCountLabelText: "")
                    }
                }
        }
        
    }
    
    func validateCreate(inputState: PasscodeInputState) {
        switch inputState {
            case .first:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.passcodeView.resetLabel(inputCountLabelText: "残り１回")
                }
            case .confirmation(let oncePasscode, let twicePasscode):
                if oncePasscode == twicePasscode {
                    indicator.flash(.success) {
                        self.settingUseCase.create(passcode: oncePasscode)
                        self.dismiss(animated: true)
                    }
                } else {
                    // バイブレーション, アラート
                    indicator.flash(.error) {
                        self.passcodeView.resetLabel(inputCountLabelText: "残り２回")
                    }
                }
        }
    }
    
    func validateChange(inputState: PasscodeInputState) {
        switch inputState {
            case .first:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.passcodeView.resetLabel(inputCountLabelText: "残り１回")
                }
            case .confirmation(let oncePasscode, let twicePasscode):
                if oncePasscode == twicePasscode {
                    indicator.flash(.success) {
                        self.settingUseCase.update(passcode: oncePasscode)
                        self.changeRootVC(TopViewController.self)
                    }
                } else {
                    // バイブレーション, アラート
                    indicator.flash(.error) {
                        self.passcodeView.resetLabel(inputCountLabelText: "新しいパスコードを\n入力してください")
                    }
                }
        }
    }
    
    func validateChangeAuthentication(inputState: PasscodeInputState) {
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
                    // バイブレーション
                    indicator.flash(.error) {
                        self.passcodeView.resetLabel(inputCountLabelText: "現在のパスコードを\n入力してください")
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
                    // バイブレーション
                    indicator.flash(.error) {
                        self.passcodeView.resetLabel(inputCountLabelText: "現在のパスコードを\n入力してください")
                    }
                }
        }
    }
    
}

// MARK: - PasscodeViewDelegate
extension PasscodeViewController: PasscodeViewDelegate {
    
    func input(inputState: PasscodeInputState) {
        switch passcodeMode {
            case .authentication:
                validateAuthentication(inputState: inputState)
            case .create:
                validateCreate(inputState: inputState)
            case .change:
                validateChange(inputState: inputState)
            case .changeAuthentication:
                validateChangeAuthentication(inputState: inputState)
        }
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension PasscodeViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() { }
    
    func dismissButtonDidTapped() {
        switch passcodeMode {
            case .authentication:
                settingUseCase.change(isPasscodeSetted: true)
            case .create:
                settingUseCase.change(isPasscodeSetted: true)
            case .change:
                settingUseCase.change(isPasscodeSetted: false)
            case .changeAuthentication:
                settingUseCase.change(isPasscodeSetted: false)
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
        switch passcodeMode {
            case .authentication:
                passcodeView.resetLabel(inputCountLabelText: "")
                subCustomNavigationBar.dismissButton(isHidden: true)
                changePasscodeButton.isHidden = false
            case .create:
                passcodeView.resetLabel(inputCountLabelText: "残り２回")
                subCustomNavigationBar.dismissButton(isHidden: false)
                changePasscodeButton.isHidden = true
            case .change:
                passcodeView.resetLabel(inputCountLabelText: "新しいパスコードを\n入力してください")
                subCustomNavigationBar.dismissButton(isHidden: false)
                changePasscodeButton.isHidden = true
            case .changeAuthentication:
                passcodeView.resetLabel(inputCountLabelText: "現在のパスコードを\n入力してください")
                subCustomNavigationBar.dismissButton(isHidden: false)
                changePasscodeButton.isHidden = true
        }
    }
    
}
