//
//  SettingViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit
import SafariServices

private enum SettingRowType: Int, CaseIterable {
    case themeColor
    case darkMode
    case passcode
    case language
    case evaluateApp
    case appIcon
    case shareApp
    case reports
    case howToUseApp
    case backup
    case privacyPolicy
    case license
    case version
    case logout
    
    var title: String {
        switch self {
            case .themeColor:
                return L10n.themeColor
            case .darkMode:
                return L10n.darkMode
            case .passcode:
                return L10n.passcode
            case .evaluateApp:
                return L10n.evaluateApp
            case .appIcon:
                return L10n.appIcon
            case .language:
                return L10n.language
            case .shareApp:
                return L10n.shareApp
            case .reports:
                return L10n.reports
            case .howToUseApp:
                return L10n.howToUseApp
            case .backup:
                return L10n.backup
            case .privacyPolicy:
                return L10n.privacyPolicy
            case .license:
                return L10n.license
            case .version:
                return L10n.version
            case .logout:
                return L10n.logout
        }
    }
    
    var image: UIImage {
        switch self {
            case .themeColor:
                return UIImage(systemName: .paintPaletteFill)
            case .darkMode:
                return UIImage(systemName: .circleRightHalfFilled)
            case .passcode:
                return UIImage(systemName: .keyFill)
            case .evaluateApp:
                return UIImage(systemName: .starFill)
            case .appIcon:
                let iconName = UserDefaults.standard.string(forKey: "IconName")
                return UIImage(named: iconName ?? "wings")!
            case .language:
                return UIImage(systemName: .globe)
            case .shareApp:
                return UIImage(systemName: .squareAndArrowUp)
            case .reports:
                return UIImage(systemName: .docText)
            case .howToUseApp:
                return UIImage(systemName: .circleHexagongridFill)
            case .backup:
                return UIImage(systemName: .icloudAndArrowUp)
            case .privacyPolicy:
                return UIImage(systemName: .lockDoc)
            case .license:
                return UIImage(systemName: .personTextRectangle)
            case .version:
                return UIImage(systemName: .checkerboardShield)
            case .logout:
                return UIImage()
        }
    }
}

protocol SettingVCDelegate: ScreenPresentationDelegate {
    func presentThankYouView()
}

final class SettingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: SettingVCDelegate?
    private let userUseCase = UserUseCase(
        repository: UserRepository(
            dataStore: FirebaseUserDataStore()
        )
    )
    private let settingUseCase = SettingUseCase(
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
        let alert = Alert.create(message: L10n.areYouSureYouWantToLogOut)
            .addAction(title: L10n.logout,
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
                       .addAction(title: L10n.close)
        present(alert, animated: true)
    }
    
    func presentLoginAndSignUpVC() {
        present(LoginAndSignUpViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.authViewType = .login
            self.delegate?.scroll(sourceScreenType: .setting,
                                  destinationScreenType: .record,
                                  completion: nil)
        }
    }
    
    func presentThemeColorActionSheet() {
        let alert = Alert.create(preferredStyle: .actionSheet)
            .addAction(title: L10n.default) {
                self.presentDefaultAlert()
            }
            .addAction(title: L10n.custom) {
                self.present(ThemeColorViewController.self,
                             modalPresentationStyle: .fullScreen) { vc in
                    vc.colorConcept = nil
                    vc.containerType = .tile
                    vc.navigationTitle = L10n.custom
                }
            }
            .addAction(title: L10n.recommendation) {
                self.present(ColorConceptViewController.self,
                             modalPresentationStyle: .fullScreen)
            }
            .addAction(title: L10n.close, style: .cancel)
        present(alert, animated: true)
    }
    
    func presentDefaultAlert() {
        let alert = Alert.create(title: L10n.doYouWantTheDefaultColor)
            .addAction(title: L10n.no)
            .addAction(title: L10n.yes) {
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
        let text = L10n.appShareDescription
        guard let shareURL = URL(string: Constant.appShareURLString) else { return }
        let activityVC = UIActivityViewController(activityItems: [text, shareURL],
                                                  applicationActivities: nil)
        activityVC.excludedActivityTypes = [
            .saveToCameraRoll,
            .message,
            .print
        ]
        present(activityVC, animated: true)
    }
    
    func requestReview() {
        // MARK: - ToDo App Storeに遷移する
    }
    
    func presentPrivacyPolicyWebPage() {
        let urlString: String = {
            switch Locale.language {
                case .ja: return Constant.privacyPolicyJaWebPage
                case .en: return Constant.privacyPolicyEnWebPage
            }
        }()
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        present(safariVC, animated: true)
    }
    
    func presentOpenIPhoneSettingsAlert() {
        let title = L10n.doYouWantToMoveToTheSettingScreen
        let message = L10n.ifYouChangeTheLanguageOnTheSettingScreenAndOpenThisAppAgain
        let alert = Alert.create(message: title + "\n" + message)
            .addAction(title: L10n.no)
            .addAction(title: L10n.yes) {
                self.openSettings()
            }
        present(alert, animated: true)
    }
    
    func openSettings() {
        let settingsURLString = UIApplication.openSettingsURLString
        guard let url = URL(string: settingsURLString) else { return }
        UIApplication.shared.open(url)
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
                present(PasscodeSettingViewController.self) { vc in
                    self.halfModalPresenter.viewController = vc
                }
            case .evaluateApp:
                requestReview()
            case .appIcon:
                present(AppIconViewController.self,
                        modalPresentationStyle: .fullScreen)
            case .language:
                presentOpenIPhoneSettingsAlert()
            case .shareApp:
                presentActivityVC()
            case .reports:
                present(ReportsViewController.self,
                        modalPresentationStyle: .fullScreen) { vc in
                    vc.delegate = self
                }
            case .howToUseApp:
                present(HowToUseViewController.self)
            case .backup:
                present(BackupViewController.self,
                        modalPresentationStyle: .fullScreen)
            case .privacyPolicy:
                presentPrivacyPolicyWebPage()
            case .license:
                openSettings()
            case .version:
                break
            case .logout:
                break
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
        let rowType = SettingRowType.allCases[indexPath.row]
        switch rowType {
            case .logout:
                let cell = tableView.dequeueReusableCustomCell(with: CustomButtonTableViewCell.self)
                cell.configure(title: rowType.title)
                cell.onTapEvent = { self.presentLogoutAlert() }
                return cell
            case .version:
                let cell = tableView.dequeueReusableCustomCell(with: AppVersionTableViewCell.self)
                cell.configure(title: rowType.title,
                               version: Constant.appVersion,
                               image: rowType.image.setColor(.mainColor ?? .black))
                return cell
            case .appIcon:
                let cell = tableView.dequeueReusableCustomCell(with: AppIconTableViewCell.self)
                cell.configure(title: rowType.title,
                               image: rowType.image.setColor(.mainColor ?? .black))
                return cell
            default:
                let cell = tableView.dequeueReusableCustomCell(with: SettingTableViewCell.self)
                cell.configure(title: rowType.title,
                               image: rowType.image.setColor(.mainColor ?? .black))
                return cell
        }
    }
    
}

// MARK: - ReportsVCDelegate
extension SettingViewController: ReportsVCDelegate {
    
    func presentThankYouView() {
        delegate?.presentThankYouView()
    }
    
}

// MARK: - setup
private extension SettingViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(SettingTableViewCell.self)
        tableView.registerCustomCell(CustomButtonTableViewCell.self)
        tableView.registerCustomCell(AppVersionTableViewCell.self)
        tableView.registerCustomCell(AppIconTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
}
