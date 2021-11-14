//
//  UITableView+Extension.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/03.
//

import UIKit

extension UITableView {

    func registerCustomCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(
            UINib(nibName: T.identifier, bundle: nil),
            forCellReuseIdentifier: T.identifier
        )
    }

    func dequeueReusableCustomCell<T: UITableViewCell>(with cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }

    func registerCustomCell<T: UITableViewHeaderFooterView>(_ cellType: T.Type) {
        register(
            UINib(nibName: T.identifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: T.identifier
        )
    }

    func dequeueReusableCustomHeaderFooterView<T: UITableViewHeaderFooterView>(with cellType: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }

}
