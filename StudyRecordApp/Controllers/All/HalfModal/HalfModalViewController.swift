//
//  HalfModalViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/24.
//

import UIKit

final class HalfModalViewController: UIViewController {

    @IBOutlet private weak var contentView: UIView!
    
    static func instantiate() -> HalfModalViewController {
        let storyboard = UIStoryboard(name: "HalfModal", bundle: nil)
        let modalVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! HalfModalViewController
        return modalVC
    }

}

// MARK: - HalfModalPresenterDelegate
extension HalfModalViewController: HalfModalPresenterDelegate {
    
    var halfModalContentHeight: CGFloat {
        return contentView.frame.height
    }
    
}
