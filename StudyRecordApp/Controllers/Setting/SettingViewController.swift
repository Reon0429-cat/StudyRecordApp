//
//  SettingViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

final class SettingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var accentView: UIView!
    
    private struct Section {
        var title: String
        var expanded: Bool
        static let data = [Section(title: "A", expanded: false),
                          Section(title: "テーマカラー", expanded: false),
                          Section(title: "B", expanded: false),
                          Section(title: "C", expanded: false)]
    }
    private struct Row {
        let title: String
        static let data = [Row(title: "デフォルト"),
                           Row(title: "セルフ"),
                           Row(title: "オススメ")]
    }
    private var sections = Section.data
    private let rows = Row.data
    
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
        switch rows[indexPath.row].title {
            case "デフォルト":
                let alert = UIAlertController(title: "デフォルトカラーにしますか？", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "閉じる", style: .destructive, handler: nil))
                alert.addAction(UIAlertAction(title: "する", style: .default) { _ in
                    UserDefaults.standard.save(color: nil, .main)
                    UserDefaults.standard.save(color: nil, .sub)
                    UserDefaults.standard.save(color: nil, .accent)
                    self.expand(section: indexPath.section)
                })
                present(alert, animated: true, completion: nil)
            case "セルフ":
                let themeColorVC = ThemeColorViewController.instantiate(containerType: .tile,
                                                                        colorConcept: nil)
                navigationController?.pushViewController(themeColorVC, animated: true)
            case "オススメ":
                let colorConceptVC = ColorConceptViewController.instantiate()
                navigationController?.pushViewController(colorConceptVC, animated: true)
            default:
                fatalError("予期せぬタイトルがあります。")
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].expanded ? 60 : 0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCustomHeaderFooterView(with: SectionHeaderView.self)
        headerView.configure(title: sections[section].title) { [weak self] in
            if self?.sections[section].title == "テーマカラー" {
                self?.expand(section: section)
            }
        }
        return headerView
    }
    
    private func expand(section: Int) {
        sections[section].expanded.toggle()
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: section)],
                             with: .automatic)
        tableView.endUpdates()
    }
    
}

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch sections[section].title {
            case "テーマカラー":
                return rows.count
            case "A", "B", "C":
                return 0
            default:
                fatalError("予期せぬタイトルがあります。")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: AccordionTableViewCell.self)
        let title = rows[indexPath.row].title
        cell.configure(title: title)
        return cell
    }
    
}
