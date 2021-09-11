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
    
    weak var delegate: ColorChoicesConceptVCDelegate?
    var colorConcept: ColorConcept?
    private var titles: [String] {
        return colorConcept?.subConceptTitles ?? []
    }
    private var colors: [[UIColor]] {
        return colorConcept?.colors ?? []
    }
    private struct Row {
        var title: String
        var isExpanded: Bool
    }
    private var rows = [Row]()
    private var lastTappedRowIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableViewData()
        
    }
    
}

// MARK: - UITableViewDelegate
extension ColorChoicesConceptViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rows[indexPath.row].isExpanded ? tableView.rowHeight : 60
    }
    
}

// MARK: - UITableViewDataSource
extension ColorChoicesConceptViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: AccordionColorTableViewCell.self)
        cell.configure(title: titles[indexPath.row],
                       colors: colors[indexPath.row])
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
    
}

// MARK: - AccordionColorTableViewCellDelegate
extension ColorChoicesConceptViewController: AccordionColorTableViewCellDelegate {
    
    func titleViewDidTapped(index: Int) {
        tableView.beginUpdates()
        var indexPaths = [IndexPath(row: index, section: 0)]
        rows[index].isExpanded.toggle()
        if let lastTappedRowIndex = lastTappedRowIndex,
           lastTappedRowIndex != index {
            rows[lastTappedRowIndex].isExpanded = false
            indexPaths.append(IndexPath(row: lastTappedRowIndex, section: 0))
        }
        tableView.reloadRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
        lastTappedRowIndex = index
        let isExpanded = rows[index].isExpanded
        delegate?.subConceptTitleDidTapped(isExpanded: isExpanded)
    }
    
    func tileViewDidTapped(selectedView: TileView, isLast: Bool, index: Int) {
        switch selectedView.getState() {
            case .circle:
                selectedView.change(state: .square)
            case .square:
                delegate?.subConceptTileViewDidTapped(view: selectedView)
        }
        if isLast {
            delegate?.subConceptTitleDidTapped(isExpanded: true)
            tableView.reloadRows(at: [IndexPath(row: index,
                                                section: 0)],
                                 with: .automatic)
        }
    }
    
}

// MARK: - setup
private extension ColorChoicesConceptViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(AccordionColorTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    func setupTableViewData() {
        titles.forEach { title in
            rows.append(Row(title: title, isExpanded: false))
        }
    }
    
}
