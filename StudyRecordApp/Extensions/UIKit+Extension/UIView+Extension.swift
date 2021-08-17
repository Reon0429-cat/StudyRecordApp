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

enum VibrateAction {
    case start
    case stop
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
    
    func vibrate(_ vibrateAction: VibrateAction, isEvenIndex: Bool = false) {
        let vibrateKey = "VibrateAnimationKey"
        let rotationKey = "transform.rotation"
        switch vibrateAction {
            case .start:
                guard self.layer.animation(forKey: vibrateKey) == nil else { return }
                let animation = CABasicAnimation(keyPath: rotationKey)
                animation.beginTime = 0.1
                animation.isRemovedOnCompletion = false
                animation.duration = 0.12
                let range = isEvenIndex ? 1.2 : -1.2
                animation.fromValue = range * Double.pi / 180
                animation.toValue = -range * Double.pi / 180
                animation.repeatCount = .infinity
                animation.autoreverses = true
                self.layer.add(animation, forKey: vibrateKey)
            case .stop:
                self.layer.removeAnimation(forKey: vibrateKey)
        }
    }
    
}
