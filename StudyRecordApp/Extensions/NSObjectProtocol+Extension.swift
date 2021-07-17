//
//  NSObjectProtocol+Extension.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/03.
//

import Foundation

extension NSObjectProtocol {

    static var className: String {
        return String(describing: self)
    }

}
