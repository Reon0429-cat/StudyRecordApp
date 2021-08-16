//
//  UIView+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/17.
//

import UIKit

enum FadeType {
    case out
    case `in`
}

extension UIView {
    
    func setFade(_ fadeType: FadeType) {
        let duration = 0.2
        switch fadeType {
            case .out:
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: .curveEaseIn) {
                    self.alpha = 0
                } completion: { _ in
                    self.isHidden = true
                }
            case .in:
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: .curveEaseIn) {
                    self.isHidden = false
                } completion: { _ in
                    UIView.animate(withDuration: duration,
                                   delay: 0,
                                   options: .curveEaseIn) {
                        self.alpha = 1
                    }
                }
        }
    }
    
}
