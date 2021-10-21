//
//  DarkModeSettingViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/14.
//

import UIKit

// MARK: - ToDo バグなおす

final class DarkModeSettingViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var darkModeBaseView: UIView!
    @IBOutlet private weak var settingAppLabel: UILabel!
    @IBOutlet private weak var settingDarkModeLabel: UILabel!
    @IBOutlet private weak var settingAutoLabel: UILabel!
    @IBOutlet private weak var settingAppSwitch: CustomSwitch!
    @IBOutlet private weak var settingDarkModeSwitch: CustomSwitch!
    @IBOutlet private weak var settingAutoSwitch: CustomSwitch!
    
    private var settingUseCase = SettingUseCase(
        repository: SettingRepository(
            dataStore: RealmSettingDataStore()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSettingAppLabel()
        setupDarkModeLabel()
        setupSettingAutoLabel()
        setupSettingAppSwitch()
        setupDarkModeSwitch()
        setupSettingAutoSwitch()
        setupContentView()
        setupDarkModeBaseView()
        
    }
    
}

// MARK: - IBAction func
private extension DarkModeSettingViewController {
    
    @IBAction func settingAppSwitchValueDidChanged(_ settingAppSwitch: UISwitch) {
        settingAutoSwitch.isOn.toggle()
        darkModeBaseView.isHidden.toggle()
        if settingAppSwitch.isOn {
            settingUseCase.change(darkModeSettingType: .app)
            let mode: UIUserInterfaceStyle = settingDarkModeSwitch.isOn ? .dark : .light
            notifyBrightnessDidChanged(mode: mode)
        } else {
            settingUseCase.change(darkModeSettingType: .auto)
            let mode: UIUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            notifyBrightnessDidChanged(mode: mode)
        }
    }
    
    @IBAction func settingDarkModeSwitchValueDidChanged(_ settingDarkModeSwitch: UISwitch) {
        settingUseCase.change(isDarkMode: settingDarkModeSwitch.isOn)
        let mode: UIUserInterfaceStyle = settingDarkModeSwitch.isOn ? .dark : .light
        notifyBrightnessDidChanged(mode: mode)
    }
    
    @IBAction func settingAutoSwitchValueDidChanged(_ settingAutoSwitch: UISwitch) {
        settingAppSwitch.isOn.toggle()
        darkModeBaseView.isHidden.toggle()
        if settingAutoSwitch.isOn {
            settingUseCase.change(darkModeSettingType: .auto)
            let isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
            settingUseCase.change(isDarkMode: isDarkMode)
            let mode: UIUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            notifyBrightnessDidChanged(mode: mode)
        } else {
            settingUseCase.change(darkModeSettingType: .app)
            settingUseCase.change(isDarkMode: settingDarkModeSwitch.isOn)
            let mode: UIUserInterfaceStyle = settingDarkModeSwitch.isOn ? .dark : .light
            notifyBrightnessDidChanged(mode: mode)
        }
    }
    
}

// MARK: - func
private extension DarkModeSettingViewController {
    
    func notifyBrightnessDidChanged(mode: UIUserInterfaceStyle) {
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
        settingAppLabel.text = L10n.darkModeSettingApp
    }
    
    func setupDarkModeLabel() {
        settingDarkModeLabel.text = L10n.darkMode
    }
    
    func setupSettingAutoLabel() {
        settingAutoLabel.text = L10n.darkModeSettingAuto
    }
    
    func setupSettingAppSwitch() {
        settingAppSwitch.isOn = settingUseCase.setting.darkModeSettingType == .app
    }
    
    func setupDarkModeSwitch() {
        settingDarkModeSwitch.isOn = settingUseCase.setting.isDarkMode
    }
    
    func setupSettingAutoSwitch() {
        settingAutoSwitch.isOn = settingUseCase.setting.darkModeSettingType == .auto
    }
    
    func setupDarkModeBaseView() {
        darkModeBaseView.isHidden = !settingAppSwitch.isOn
    }
    
}
