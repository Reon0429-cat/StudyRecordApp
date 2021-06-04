//
//  DrawView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

final class DrawView: UIView {
    
    override func draw(_ rect: CGRect) {
        let arc = UIBezierPath(arcCenter: CGPoint(x: 50, y: 0),
                               radius: 50,
                               startAngle: 0,
                               endAngle: CGFloat(Double.pi) * 2,
                               clockwise: true)
        let color = UIColor.gray
        color.setStroke()
        arc.lineWidth = 1
        arc.lineCapStyle = .round
        arc.stroke()
    }
    
}
