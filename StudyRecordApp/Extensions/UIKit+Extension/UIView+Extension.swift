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
        switch fadeType {
            case .out:
                animate {
                    self.alpha = 0
                } completion: {
                    self.isHidden = true
                }
            case .in:
                animate {
                    self.isHidden = false
                } completion: {
                    self.alpha = 1
                }
        }
    }
    
    private func animate(animations: @escaping () -> Void,
                         completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn) {
            animations()
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                completion()
            }
        }
    }
    
    func toggleFade() {
        if self.isHidden {
            self.setFade(.in)
        } else {
            self.setFade(.out)
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
    
    func cutToCircle(borderColor: UIColor?, width: CGFloat?) {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = borderColor?.cgColor ?? UIColor.clear.cgColor
        self.layer.borderWidth = width ?? 0
    }
    
    static func animate(deadlineFromNow: Double,
                        duration: Double = 1,
                        _ animation: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + deadlineFromNow) {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: []) {
                animation()
            }
        }
    }
    
    func setShadow(color: UIColor = .black,
                   radius: CGFloat = 2,
                   opacity: Float = 0.8,
                   width: Double = 2,
                   height: Double = 2,
                   rect: (distance: CGFloat,
                          height: CGFloat)? = nil) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        guard let rect = rect else {
            self.layer.shadowPath = nil
            return
        }
        let height: CGFloat = rect.height
        let distance: CGFloat = rect.distance
        let _rect = CGRect(
            x: 0,
            y: self.frame.height - distance,
            width: self.frame.width,
            height: height
        )
        self.layer.shadowPath = UIBezierPath(ovalIn: _rect).cgPath
    }
    
}
