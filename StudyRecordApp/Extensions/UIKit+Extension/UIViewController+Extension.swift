//
//  UIViewController+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/24.
//

import UIKit

extension UIViewController {
    
    func present<T: UIViewController>(_ ViewControllerType: T.Type,
                                      modalPresentationStyle: UIModalPresentationStyle = .automatic,
                                      modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
                                      handler: ((T) -> Void)? = nil,
                                      completion: (() -> Void)? = nil) {
        let vc = ViewControllerType.instantiate()
        vc.modalPresentationStyle = modalPresentationStyle
        vc.modalTransitionStyle = modalTransitionStyle
        handler?(vc)
        present(vc, animated: true, completion: completion)
    }
    
    func push<T: UIViewController>(_ ViewControllerType: T.Type,
                                   handler: ((T) -> Void)? = nil) {
        let vc = ViewControllerType.instantiate()
        handler?(vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeRootVC<T: UIViewController>(_ ViewControllerType: T.Type) {
        let connectedScenes = UIApplication.shared.connectedScenes
        guard let sceneDelegate = connectedScenes.first?.delegate as? SceneDelegate else { return }
        let vc = ViewControllerType.instantiate()
        sceneDelegate.window?.rootViewController = vc
    }
    
    func getPresentedVC() -> UIViewController? {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard var vc = window?.rootViewController else { return nil }
        while let presentedViewController = vc.presentedViewController {
            vc = presentedViewController
        }
        return vc
    }
    
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
    
    func showErrorAlert(title: String,
                        message: String? = nil,
                        handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            .addAction(title: LocalizeKey.close.localizedString(),
                       style: .default,
                       handler: handler)
        present(alert, animated: true)
    }
    
}
