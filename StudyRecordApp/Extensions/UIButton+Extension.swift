//
//  UIButton+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/10.
//

import UIKit

extension UIButton {
    
    func setTitle(_ title: String) {
        self.setTitle(title, for: .normal)
        UIView.setAnimationsEnabled(false)
        self.setTitle(title, for: .normal)
        self.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
}
