//
//  DarkModeSettingViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/14.
//

import UIKit

final class DarkModeSettingViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var settingAppLabel: UILabel!
    @IBOutlet private weak var settingAutoLabel: UILabel!
    @IBOutlet private weak var settingAppSwitch: CustomSwitch!
    @IBOutlet private weak var settingAutoSwitch: CustomSwitch!
    
    private var settingUseCase = SettingUseCase(
        repository: SettingRepository(
            dataStore: RealmSettingDataStore()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSettingAppLabel()
        setupSettingAutoLabel()
        setupSettingAppSwitch()
        setupSettingAutoSwitch()
        setupContentView()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            
        }
    }
    
}

// MARK: - IBAction func
private extension DarkModeSettingViewController {
    
    @IBAction func settingAppSwitchValueDidChanged(_ settingAppSwitch: UISwitch) {
        settingAutoSwitch.isOn.toggle()
        if settingAppSwitch.isOn {
            settingUseCase.change(darkModeSettingType: .app)
        }
        let mode: UIUserInterfaceStyle = settingAppSwitch.isOn ? .dark : .light
        NotificationCenter.default.post(name: .brightnessDidChanged,
                                        object: nil,
                                        userInfo: ["mode": mode])
    }
    
    @IBAction func settingAutoSwitchValueDidChanged(_ settingAutoSwitch: UISwitch) {
        settingAppSwitch.isOn.toggle()
        if settingAutoSwitch.isOn {
            settingUseCase.change(darkModeSettingType: .auto)
        }
        let mode: UIUserInterfaceStyle = settingAutoSwitch.isOn ? .dark : .light
        NotificationCenter.default.post(name: .brightnessDidChanged,
                                        object: nil,
                                        userInfo: ["mode": mode])
    }
    
}

// MARK: - HalfModalPresenterDelegate
extension DarkModeSettingViewController: HalfModalPresenterDelegate {
    
    var halfModalContentHeight: CGFloat {
        return contentView.frame.height
    }
    
}

// MARK: - setup
private extension DarkModeSettingViewController {
    
    func setupContentView() {
        contentView.backgroundColor = .dynamicColor(light: .white,
                                                    dark: .secondarySystemGroupedBackground)
    }
    
    func setupSettingAppLabel() {
        settingAppLabel.text = LocalizeKey.darkModeSettingApp.localizedString()
    }
    
    func setupSettingAutoLabel() {
        settingAutoLabel.text = LocalizeKey.darkModeSettingAuto.localizedString()
    }
    
    func setupSettingAppSwitch() {
        settingAppSwitch.isOn = settingUseCase.setting.darkModeSettingType == .app
    }
    
    func setupSettingAutoSwitch() {
        settingAutoSwitch.isOn = settingUseCase.setting.darkModeSettingType == .auto
    }
    
}
