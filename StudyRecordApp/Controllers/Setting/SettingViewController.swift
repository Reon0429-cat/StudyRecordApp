//
//  SettingViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

private enum SectionType: CaseIterable {
    case a
    case themeColor
    case b
    
    var title: String {
        switch self {
            case .a: return "サンプルA"
            case .themeColor: return "テーマカラー"
            case .b: return "サンプルB"
        }
    }
    var rowTypes: [RowType] {
        switch self {
            case .a: return [.sample1, .sample2]
            case .themeColor: return [.default, .custom, .recommend]
            case .b: return [.sample100]
        }
    }
}

private enum RowType {
    case sample1
    case sample2
    
    case `default`
    case custom
    case recommend
    
    case sample100
    
    var title: String {
        switch self {
            case .sample1: return "サンプル１"
            case .sample2: return "サンプル２"
                
            case .default: return "デフォルト"
            case .custom: return "カスタム"
            case .recommend: return "オススメ"
                
            case .sample100: return "サンプル100"
        }
    }
}

protocol SettingVCDelegate: AnyObject {
    func viewWillAppear(index: Int)
    func loginAndSignUpVCDidShowed()
}

final class SettingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var tables: [(sectionType: SectionType, isExpanded: Bool)] = {
        var tables = [(sectionType: SectionType, isExpanded: Bool)]()
        SectionType.allCases.forEach { sectionType in
            tables.append((sectionType: sectionType, isExpanded: false))
        }
        return tables
    }()
    weak var delegate: SettingVCDelegate?
    private var userUseCase = UserUseCase(
        repository: UserRepository(
            dataStore: FirebaseUserDataStore()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.viewWillAppear(index: self.view.tag)
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(AccordionTableViewCell.self)
        tableView.registerCustomCell(SectionHeaderView.self)
        tableView.tableFooterView = UIView()
    }
    
    @IBAction private func logoutButtonDidTapped(_ sender: Any) {
        let alert = UIAlertController(title: "本当にログアウトしてもよろしいですか",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .destructive))
        alert.addAction(UIAlertAction(title: "ログアウト", style: .default) { _ in
            Indicator().show(.progress)
            self.userUseCase.logout { result in
                switch result {
                    case .failure(let title):
                        Indicator().flash(.error) {
                            self.showErrorAlert(title: title)
                        }
                    case .success:
                        Indicator().flash(.success) {
                            let loginAndSignUpVC = LoginAndSignUpViewController.instantiate()
                            loginAndSignUpVC.modalPresentationStyle = .fullScreen
                            self.present(loginAndSignUpVC, animated: true) {
                                self.delegate?.loginAndSignUpVCDidShowed()
                            }
                        }
                }
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let rowType = tables[indexPath.section].sectionType.rowTypes[indexPath.row]
        switch rowType {
            case .sample1:
                break
            case .sample2:
                break
            case .default:
                showAlert(section: indexPath.section)
            case .custom:
                let themeColorVC = ThemeColorViewController.instantiate(containerType: .tile, colorConcept: nil)
                navigationController?.pushViewController(themeColorVC, animated: true)
            case .recommend:
                let colorConceptVC = ColorConceptViewController.instantiate()
                navigationController?.pushViewController(colorConceptVC, animated: true)
            case .sample100:
                break
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
                case .a:
                    break
                case .themeColor:
                    self.expand(section: section)
                case .b:
                    break
            }
        }
        return headerView
    }
    
    private func showAlert(section: Int) {
        let alert = UIAlertController(title: "デフォルトカラーにしますか？",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "いいえ", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "はい", style: .default) { _ in
            UserDefaults.standard.save(color: nil, .main)
            UserDefaults.standard.save(color: nil, .sub)
            UserDefaults.standard.save(color: nil, .accent)
            self.expand(section: section)
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func expand(section: Int) {
        tables[section].isExpanded.toggle()
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: section)],
                             with: .automatic)
        tableView.endUpdates()
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
