//
//  ColorConceptViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

final class ColorConceptViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let colorConcepts = ColorConcept.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(ColorConceptTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    static func instantiate() -> ColorConceptViewController {
        let colorConceptVC = UIStoryboard(
            name: "ColorConcept",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: ColorConceptViewController.identifier
        ) as! ColorConceptViewController
        return colorConceptVC
    }
    
}

extension ColorConceptViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let themeColorVC = ThemeColorViewController.instantiate(containerType: .concept,
                                                                colorConcept: colorConcepts[indexPath.row])
        self.navigationController?.pushViewController(themeColorVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension ColorConceptViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorConcepts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: ColorConceptTableViewCell.self)
        let title = colorConcepts[indexPath.row].title
        cell.configure(title: title)
        cell.selectionStyle = .none
        return cell
    }
    
}







