//
//  UIAlertController+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

extension UIAlertController {
    
    static func withTextField(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "追加", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        return alert
    }
    
}
