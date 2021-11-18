//
//  UICollectionView+Extension.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/03.
//

import UIKit

extension UICollectionView {

    func registerCustomCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(
            UINib(nibName: T.identifier, bundle: nil),
            forCellWithReuseIdentifier: T.identifier
        )
    }

    func dequeueReusableCustomCell<T: UICollectionViewCell>(with cellType: T.Type,
                                                            indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier,
                                   for: indexPath) as! T
    }

}
