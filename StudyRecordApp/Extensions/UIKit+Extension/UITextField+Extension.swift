//
//  UITextField+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit

extension UITextField {
    
    func setUnderLine() {
        self.borderStyle = .none
        let underline = UIView()
        underline.frame = CGRect(x: 0,
                                 y: self.frame.height,
                                 width: self.frame.width,
                                 height: 2)
        underline.backgroundColor = .dynamicColor(light: .black, dark: .white)
        self.addSubview(underline)
        self.bringSubviewToFront(underline)
    }
    
}
