//
//  SettingViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

private enum SectionType: CaseIterable {
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
            case .themeColor: return "テーマカラー"
            case .darkMode: return "ダークモード"
            case .passcode: return "パスコード"
            case .pushNotification: return "プッシュ通知"
            case .multilingual: return "言語"
            case .howToUseApp: return "アプリの使い方"
            case .evaluationApp: return "アプリを評価する"
            case .shareApp: return "アプリを共有する"
            case .reports: return "ご意見、ご要望、不具合の報告"
            case .backup: return "バックアップ"
            case .privacyPolicy: return "プライバシーポリシー"
            case .logout: return "ログアウト"
                
        }
    }
    var rowTypes: [RowType] {
        switch self {
            case .themeColor: return [.default, .custom, .recommend]
            default: return []
        }
    }
}

private enum RowType {
    case `default`
    case custom
    case recommend
    
    var title: String {
        switch self {
            case .default: return "デフォルト"
            case .custom: return "カスタム"
            case .recommend: return "オススメ"
        }
    }
}

protocol SettingVCDelegate: ScreenPresentationDelegate {
    
}

final class SettingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: SettingVCDelegate?
    private var tables: [(sectionType: SectionType, isExpanded: Bool)] = {
        var tables = [(sectionType: SectionType, isExpanded: Bool)]()
        SectionType.allCases.forEach { sectionType in
            tables.append((sectionType: sectionType, isExpanded: false))
        }
        return tables
    }()
    private var userUseCase = UserUseCase(
        repository: UserRepository(
            dataStore: FirebaseUserDataStore()
        )
    )
    private let indicator = Indicator(kinds: PKHUDIndicator())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.screenDidPresented(screenType: .setting)
        
    }
    
}

// MARK: - IBAction func
private extension SettingViewController {
    
//    @IBAction func logoutButtonDidTapped(_ sender: Any) {
//        let alert = Alert.create(title: "本当にログアウトしてもよろしいですか")
//            .addAction(title: "ログアウト", style: .destructive) {
//                self.indicator.show(.progress)
//                self.userUseCase.logout { result in
//                    switch result {
//                        case .failure(let title):
//                            self.indicator.flash(.error) {
//                                self.showErrorAlert(title: title)
//                            }
//                        case .success:
//                            self.indicator.flash(.success) {
//                                self.presentLoginAndSignUpVC()
//                            }
//                    }
//                }
//            }
//            .addAction(title: "閉じる")
//        present(alert, animated: true)
//    }
    
    func presentLoginAndSignUpVC() {
        present(LoginAndSignUpViewController.self,
                modalPresentationStyle: .fullScreen) { _ in
            self.delegate?.scroll(sourceScreenType: .setting,
                                  destinationScreenType: .record,
                                  completion: nil)
        }
    }
    
    func showAlert(section: Int) {
        let alert = Alert.create(title: "デフォルトカラーにしますか？")
            .addAction(title: "いいえ")
            .addAction(title: "はい") {
                UserDefaults.standard.save(color: nil, .main)
                UserDefaults.standard.save(color: nil, .sub)
                UserDefaults.standard.save(color: nil, .accent)
                self.expand(section: section)
            }
        present(alert, animated: true)
    }
    
    func expand(section: Int) {
        tables[section].isExpanded.toggle()
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0,
                                            section: section)],
                             with: .automatic)
        tableView.endUpdates()
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let rowType = tables[indexPath.section].sectionType.rowTypes[indexPath.row]
        switch rowType {
            case .default:
                showAlert(section: indexPath.section)
            case .custom:
                present(ThemeColorViewController.self,
                        modalPresentationStyle: .fullScreen) { vc in
                    vc.colorConcept = nil
                    vc.containerType = .tile
                    vc.navTitle = "セルフ"
                }
            case .recommend:
                present(ColorConceptViewController.self,
                        modalPresentationStyle: .fullScreen)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tables[indexPath.section].isExpanded ? 60 : 0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCustomHeaderFooterView(with: SectionHeaderView.self)
        headerView.configure(title: tables[section].sectionType.title) { [weak self] in
            guard let self = self else { return }
            switch self.tables[section].sectionType {
                case .themeColor:
                    self.expand(section: section)
                default:
                    break
            }
        }
        return headerView
    }
    
}

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tables[section].sectionType.rowTypes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: AccordionTableViewCell.self)
        let title = tables[indexPath.section].sectionType.rowTypes[indexPath.row].title
        cell.configure(title: title)
        return cell
    }
    
}

// MARK: - setup
private extension SettingViewController {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(AccordionTableViewCell.self)
        tableView.registerCustomCell(SectionHeaderView.self)
        tableView.tableFooterView = UIView()
    }
    
}
