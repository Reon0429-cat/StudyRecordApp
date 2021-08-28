//
//  UIViewController+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/24.
//

import UIKit
import PKHUD

extension UIViewController {
    
    static func instantiate() -> Self {
        var storyboardName = String(describing: self)
        if let result = storyboardName.range(of: "ViewController") {
            storyboardName.removeSubrange(result)
        } else {
            fatalError("Storyboardの名前が正しくない")
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! Self
        return vc
    }
    
    func showErrorAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func flashHUD(_ type: HUDContentType,
                  completion: @escaping () -> Void) {
        HUD.flash(type,
                  onView: nil,
                  delay: 0) { _ in
            completion()
        }
    }
    
    func showHUD(_ type: HUDContentType) {
        HUD.show(type)
    }
    
}
