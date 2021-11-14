//
//  RippleView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/17.
//

import UIKit

final class RippleView: UIView {

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        drawRipple(touch: touches.first!)

    }

    private func drawRipple(touch: UITouch) {
        let width: CGFloat = 200
        let rippleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        rippleView.layer.cornerRadius = width / 2
        rippleView.center = touch.location(in: self)
        rippleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        rippleView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.clipsToBounds = true
        self.addSubview(rippleView)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                           rippleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                           rippleView.backgroundColor = .clear
                       }, completion: { _ in
                           rippleView.removeFromSuperview()
                       })
    }

}
