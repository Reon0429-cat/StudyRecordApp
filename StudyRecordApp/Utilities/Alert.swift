//
//  Alert.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/07.
//

import UIKit

final class Alert {
    var title: String?
    var message: String?
    var preferredStyle: UIAlertController.Style = .alert
    
    static func create(title: String? = nil,
                       message: String? = nil,
                       preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        return alert
    }
}

extension UIAlertController {
    
    func addAction(title: String,
                   style: UIAlertAction.Style = .default,
                   handler: (() -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title,
                                   style: style) { _ in
            handler?()
        }
        addAction(action)
        return self
    }
    
    func setTextField(handler: @escaping (UITextField) -> Void) -> Self {
        addTextField { textField in
            handler(textField)
        }
        return self
    }
    
}
