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
    case evaluationApp
    case shareApp
    case reports
    case howToUseApp
    case backup
    case privacyPolicy
    case logout
    
    var title: String {
        switch self {
            case .themeColor: return L10n.themeColor
            case .darkMode: return L10n.darkMode
            case .passcode: return L10n.passcode
            case .evaluationApp: return L10n.evaluationApp
            case .shareApp: return L10n.shareApp
            case .reports: return L10n.reports
            case .howToUseApp: return L10n.howToUseApp
            case .backup: return L10n.backup
            case .privacyPolicy: return L10n.privacyPolicy
            case .logout: return L10n.logout
        }
    }
}

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
        let alert = Alert.create(title: L10n.areYouSureYouWantToLogOut)
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
                modalPresentationStyle: .fullScreen) { _ in
            self.delegate?.scroll(sourceScreenType: .setting,
                                  destinationScreenType: .record,
                                  completion: nil)
        }
    }
    
    func presentThemeColorActionSheet() {
        let alert = Alert.create(preferredStyle: .alert)
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
            .addAction(title: L10n.close,
                       style: .destructive)
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
                present(PasscodeSettingViewController.self) { vc in
                    self.halfModalPresenter.viewController = vc
                }
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
        let rowType = SettingRowType.allCases[indexPath.row]
        switch rowType {
            case .logout:
                let cell = tableView.dequeueReusableCustomCell(with: CustomButtonTableViewCell.self)
                cell.configure(title: rowType.title)
                cell.onTapEvent = { self.presentLogoutAlert() }
                return cell
            default:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: rowType.title)
                return cell
        }
    }
    
}

// MARK: - setup
private extension SettingViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(CustomTitleTableViewCell.self)
        tableView.registerCustomCell(CustomButtonTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
}
