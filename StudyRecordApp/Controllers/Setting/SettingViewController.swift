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
    case c
    
    var title: String {
        switch self {
            case .a: return "サンプルA"
            case .themeColor: return "テーマカラー"
            case .b: return "サンプルB"
            case .c: return "サンプルC"
        }
    }
    var rows: [RowType] {
        switch self {
            case .a: return []
            case .themeColor: return RowType.allCases
            case .b: return []
            case .c: return []
        }
    }
    enum RowType: CaseIterable {
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
}

final class SettingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var accentView: UIView!
    
    private var sections: [(sectionType: SectionType, isExpanded: Bool)] = {
        var sections = [(sectionType: SectionType, isExpanded: Bool)]()
        SectionType.allCases.forEach { sectionType in
            sections.append((sectionType: sectionType, isExpanded: false))
        }
        return sections
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupThemeColor()
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(AccordionTableViewCell.self)
        tableView.registerCustomCell(SectionHeaderView.self)
        tableView.tableFooterView = UIView()
    }
    
    private func setupThemeColor() {
        mainView.backgroundColor = ThemeColor.main
        subView.backgroundColor = ThemeColor.sub
        accentView.backgroundColor = ThemeColor.accent
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].sectionType.rows[indexPath.row]
        switch row {
            case .default:
                let alert = UIAlertController(title: "\(row.title)カラーにしますか？", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "いいえ", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "はい", style: .default) { _ in
                    UserDefaults.standard.save(color: nil, .main)
                    UserDefaults.standard.save(color: nil, .sub)
                    UserDefaults.standard.save(color: nil, .accent)
                    self.expand(section: indexPath.section)
                })
                present(alert, animated: true, completion: nil)
            case .custom:
                let themeColorVC = ThemeColorViewController.instantiate(containerType: .tile, colorConcept: nil)
                navigationController?.pushViewController(themeColorVC, animated: true)
            case .recommend:
                let colorConceptVC = ColorConceptViewController.instantiate()
                navigationController?.pushViewController(colorConceptVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].isExpanded ? 60 : 0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCustomHeaderFooterView(with: SectionHeaderView.self)
        headerView.configure(title: sections[section].sectionType.title) { [weak self] in
            guard let self = self else { return }
            if self.sections[section].sectionType == .themeColor {
                self.expand(section: section)
            }
        }
        return headerView
    }
    
    private func expand(section: Int) {
        sections[section].isExpanded.toggle()
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: section)],
                             with: .automatic)
        tableView.endUpdates()
    }
    
}

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionType.rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: AccordionTableViewCell.self)
        let title = sections[indexPath.section].sectionType.rows[indexPath.row].title
        cell.configure(title: title)
        return cell
    }
    
}
