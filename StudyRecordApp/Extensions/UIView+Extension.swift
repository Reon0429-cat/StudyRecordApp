//
//  UIView+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/06.
//

import UIKit

enum BorderPosition {
    case top
    case left
    case right
    case bottom
}

extension UIView {
    
    func addBorder(width: CGFloat, color: UIColor, position: BorderPosition) {
        let border = CALayer()
        switch position {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
                border.backgroundColor = color.cgColor
                self.layer.addSublayer(border)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
                border.backgroundColor = color.cgColor
                self.layer.addSublayer(border)
            case .right:
                print(self.frame.width)
                
                border.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
                border.backgroundColor = color.cgColor
                self.layer.addSublayer(border)
            case .bottom:
                border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
                border.backgroundColor = color.cgColor
                self.layer.addSublayer(border)
        }
    }
}
