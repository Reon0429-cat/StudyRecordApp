//
//  WaveView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/17.
//

import UIKit

final class WaveView: UIView {
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        drawWave(touch: touches.first!)
        
    }
    
    private func drawWave(touch: UITouch) {
        let width: CGFloat = 200
        let waveView = UIView(frame: CGRect(x: 0, y: 0,
                                            width: width , height: width))
        waveView.layer.cornerRadius = width / 2
        waveView.center = touch.location(in: self)
        waveView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        waveView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.clipsToBounds = true
        self.addSubview(waveView)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        waveView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        waveView.backgroundColor = .clear
                       }, completion: { finished in
                        waveView.removeFromSuperview()
                       })
    }
    
}
