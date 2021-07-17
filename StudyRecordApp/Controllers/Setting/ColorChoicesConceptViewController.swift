//
//  ColorChoicesConceptViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/30.
//

import UIKit

protocol ColorChoicesConceptVCDelegate: AnyObject {
    func subConceptTileViewDidTapped(view: UIView)
    func subConceptTitleDidTapped(isExpanded: Bool)
}

final class ColorChoicesConceptViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var colorConcept: ColorConcept?
    private var titles: [String] {
        return colorConcept?.subConceptTitles ?? []
    }
    private var colors: [[UIColor]] {
        return colorConcept?.colors ?? []
    }
    private struct Section {
        var title: String
        var expanded: Bool
    }
    private var sections = [Section]()
    private var lastTappedSection: Int? = nil
    weak var delegate: ColorChoicesConceptVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableViewData()
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(AccordionColorTableViewCell.self)
        tableView.registerCustomCell(SectionHeaderView.self)
        tableView.tableFooterView = UIView()
    }
    
    private func setupTableViewData() {
        titles.forEach { title in
            sections.append(Section(title: title, expanded: false))
        }
    }
    
}

extension ColorChoicesConceptViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].expanded ? 60 : 0
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCustomHeaderFooterView(with: SectionHeaderView.self)
        let title = sections[section].title
        headerView.configure(title: title) { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            var indexPaths = [IndexPath(row: 0, section: section)]
            self.sections[section].expanded.toggle()
            if let beforeSection = self.lastTappedSection,
               beforeSection != section {
                self.sections[beforeSection].expanded = false
                indexPaths.append(IndexPath(row: 0, section: beforeSection))
            }
            self.tableView.reloadRows(at: indexPaths, with: .automatic)
            self.tableView.endUpdates()
            self.lastTappedSection = section
            let isExpanded = self.sections[section].expanded
            self.delegate?.subConceptTitleDidTapped(isExpanded: isExpanded)
        }
        return headerView
    }
    
}

extension ColorChoicesConceptViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: AccordionColorTableViewCell.self)
        let colors = colors[indexPath.section]
        cell.configure(colors: colors) { view in
            self.delegate?.subConceptTileViewDidTapped(view: view)
        }
        cell.selectionStyle = .none
        return cell
    }
    
}
