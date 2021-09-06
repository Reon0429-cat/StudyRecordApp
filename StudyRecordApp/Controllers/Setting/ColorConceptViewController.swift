//
//  ColorConceptViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

final class ColorConceptViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
}

// MARK: - UITableViewDelegate
extension ColorConceptViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(ThemeColorViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.containerType = .concept
            vc.colorConcept = ColorConcept.allCases[indexPath.row]
            vc.navTitle = ColorConcept.allCases[indexPath.row].title
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

// MARK: - UITableViewDataSource
extension ColorConceptViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return ColorConcept.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: ColorConceptTableViewCell.self)
        let title = ColorConcept.allCases[indexPath.row].title
        cell.configure(title: title)
        return cell
    }
    
}

// MARK: - setup
private extension ColorConceptViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(ColorConceptTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
}
