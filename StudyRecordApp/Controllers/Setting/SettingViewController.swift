//
//  SettingViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

private enum SettingRowType: Int, CaseIterable {
    case themeColor
    case darkMode
    case passcode
    case pushNotification
    case multilingual
    case evaluationApp
    case shareApp
    case reports
    case howToUseApp
    case backup
    case privacyPolicy
    case logout
    
    var title: String {
        switch self {
            case .themeColor:
                return LocalizeKey.themeColor.localizedString()
            case .darkMode:
                return LocalizeKey.darkMode.localizedString()
            case .passcode:
                return LocalizeKey.passcode.localizedString()
            case .pushNotification:
                return LocalizeKey.pushNotification.localizedString()
            case .multilingual:
                return LocalizeKey.multilingual.localizedString()
            case .howToUseApp:
                return LocalizeKey.howToUseApp.localizedString()
            case .evaluationApp:
                return LocalizeKey.evaluationApp.localizedString()
            case .shareApp:
                return LocalizeKey.shareApp.localizedString()
            case .reports:
                return LocalizeKey.reports.localizedString()
            case .backup:
                return LocalizeKey.backup.localizedString()
            case .privacyPolicy:
                return LocalizeKey.privacyPolicy.localizedString()
            case .logout:
                return LocalizeKey.logout.localizedString()
                
        }
    }
}

// MARK: - ToDo 言語を日本語と英語で切り替えられるように
// MARK: - ToDo アニメーション付きでダークモードを切り替えられるように
// MARK: - ToDo ダークモード端末とアプリでそれぞれ別々に選択できるようにする
// MARK: - ToDo 言語セルはいらないので、消す

protocol SettingVCDelegate: ScreenPresentationDelegate {
    
}

final class SettingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: SettingVCDelegate?
    private var userUseCase = UserUseCase(
        repository: UserRepository(
            dataStore: FirebaseUserDataStore()
        )
    )
    private var settingUseCase = SettingUseCase(
        repository: SettingRepository(
            dataStore: RealmSettingDataStore()
        )
    )
    private let indicator = Indicator(kinds: PKHUDIndicator())
    private var halfModalPresenter = HalfModalPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.screenDidPresented(screenType: .setting,
                                     isEnabledNavigationButton: true)
        tableView.reloadData()
        
    }
    
}

// MARK: - func
private extension SettingViewController {
    
    func presentLogoutAlert() {
        let alert = Alert.create(title: LocalizeKey.areYouSureYouWantToLogOut.localizedString())
            .addAction(title: LocalizeKey.logout.localizedString(),
                       style: .destructive) {
                self.indicator.show(.progress)
                self.userUseCase.logout { result in
                    switch result {
                        case .failure(let title):
                            self.indicator.flash(.error) {
                                self.showErrorAlert(title: title)
                            }
                        case .success:
                            self.indicator.flash(.success) {
                                self.presentLoginAndSignUpVC()
                            }
                    }
                }
            }
            .addAction(title: LocalizeKey.close.localizedString())
        present(alert, animated: true)
    }
    
    func presentLoginAndSignUpVC() {
        present(LoginAndSignUpViewController.self,
                modalPresentationStyle: .fullScreen) { _ in
            self.delegate?.scroll(sourceScreenType: .setting,
                                  destinationScreenType: .record,
                                  completion: nil)
        }
    }
    
    func presentThemeColorActionSheet() {
        let alert = Alert.create(preferredStyle: .alert)
            .addAction(title: LocalizeKey.default.localizedString()) {
                self.presentDefaultAlert()
            }
            .addAction(title: LocalizeKey.custom.localizedString()) {
                self.present(ThemeColorViewController.self,
                             modalPresentationStyle: .fullScreen) { vc in
                    vc.colorConcept = nil
                    vc.containerType = .tile
                    vc.navigationTitle = LocalizeKey.custom.localizedString()
                }
            }
            .addAction(title: LocalizeKey.recommendation.localizedString()) {
                self.present(ColorConceptViewController.self,
                             modalPresentationStyle: .fullScreen)
            }
            .addAction(title: LocalizeKey.close.localizedString(),
                       style: .cancel)
        present(alert, animated: true)
    }
    
    func presentDefaultAlert() {
        let alert = Alert.create(title: LocalizeKey.doYouWantTheDefaultColor.localizedString())
            .addAction(title: LocalizeKey.no.localizedString())
            .addAction(title: LocalizeKey.yes.localizedString()) {
                UserDefaults.standard.save(color: nil, .main)
                UserDefaults.standard.save(color: nil, .sub)
                UserDefaults.standard.save(color: nil, .accent)
                NotificationCenter.default.post(name: .changedThemeColor,
                                                object: nil,
                                                userInfo: nil)
            }
        present(alert, animated: true)
    }
    
    func presentActivityVC() {
        // MARK: - ToDo 決まり次第、テキストとimageを切り替える
        let text = "テストテキスト"
        guard let image = UIImage(systemName: "star") else { return }
        let activityVC = UIActivityViewController(activityItems: [text, image],
                                                  applicationActivities: nil)
        activityVC.excludedActivityTypes = [
            .saveToCameraRoll,
            .message,
            .print
        ]
        present(activityVC, animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowType = SettingRowType.allCases[indexPath.row]
        switch rowType {
            case .themeColor:
                presentThemeColorActionSheet()
            case .darkMode:
                present(DarkModeSettingViewController.self) { vc in
                    self.halfModalPresenter.viewController = vc
                }
            case .passcode:
                break
            case .pushNotification:
                break
            case .multilingual:
                break
            case .evaluationApp:
                break
            case .shareApp:
                presentActivityVC()
            case .reports:
                break
            case .howToUseApp:
                break
            case .backup:
                break
            case .privacyPolicy:
                break
            case .logout:
                break
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return SettingRowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settingUseCase.setting
        let rowType = SettingRowType.allCases[indexPath.row]
        switch rowType {
            case .themeColor,
                 .multilingual,
                 .evaluationApp,
                 .darkMode,
                 .shareApp,
                 .reports,
                 .howToUseApp,
                 .backup,
                 .privacyPolicy:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: rowType.title)
                return cell
            case .passcode:
                let cell = tableView.dequeueReusableCustomCell(with: CustomSwitchTableViewCell.self)
                cell.configure(title: rowType.title,
                               isOn: setting.isPasscodeSetted) { isOn in
                    self.settingUseCase.change(isPasscodeSetted: isOn)
                    if !self.settingUseCase.isPasscodeCreated && isOn {
                        self.present(PasscodeViewController.self,
                                     modalPresentationStyle: .fullScreen) { vc in
                            vc.passcodeMode = .create
                        }
                    }
                }
                return cell
            case .pushNotification:
                let cell = tableView.dequeueReusableCustomCell(with: CustomSwitchTableViewCell.self)
                cell.configure(title: rowType.title,
                               isOn: setting.isPushNotificationSetted) { isOn in
                    self.settingUseCase.change(isPushNotificationSetted: isOn)
                }
                return cell
            case .logout:
                let cell = tableView.dequeueReusableCustomCell(with: CustomButtonTableViewCell.self)
                cell.configure(title: rowType.title)
                cell.onTapEvent = { self.presentLogoutAlert() }
                return cell
        }
    }
    
}

// MARK: - setup
private extension SettingViewController {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(CustomTitleTableViewCell.self)
        tableView.registerCustomCell(CustomSwitchTableViewCell.self)
        tableView.registerCustomCell(CustomButtonTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
}
