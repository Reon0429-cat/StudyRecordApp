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
    case forgot
    
    var title: String {
        switch self {
            case .authentication: return "認証"
            case .create: return "作成"
            case .change: return "変更"
            case .forgot: return "再設定"
        }
    }
}

// MARK: - ToDo パスコード、変更、忘れた時の対処
// MARK: - ToDo　認証が失敗したときにバイブレーション

final class PasscodeViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var passcodeView: PasscodeView!
    
    private let indicator = Indicator(kinds: PKHUDIndicator())
    private var settingUseCase = SettingUseCase(
        repository: SettingRepository(
            dataStore: RealmSettingDataStore()
        )
    )
    var passcodeMode: PasscodeMode = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPasscodeMode()
        setupSubCustomNavigationBar()
        setupPasscodeView()
        
    }
    
}

// MARK: - PasscodeViewDelegate
extension PasscodeViewController: PasscodeViewDelegate {
    
    func validate(passcode: String) {
        switch passcodeMode {
            case .authentication:
                if settingUseCase.isSame(passcode: passcode) {
                    indicator.flash(.success) {
                        self.changeRootVC(TopViewController.self)
                    }
                } else {
                    indicator.flash(.error) {
                        self.passcodeView.failure()
                    }
                }
            case .create:
                settingUseCase.create(passcode: passcode)
                dismiss(animated: true)
            case .change:
                // update
                break
            case .forgot:
                // update
                break
        }
    }
    
}

extension PasscodeViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() { }
    
    func dismissButtonDidTapped() { }
    
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
        subCustomNavigationBar.dismissButton(isHidden: true)
    }
    
    func setupPasscodeMode() {
        
    }
    
}
