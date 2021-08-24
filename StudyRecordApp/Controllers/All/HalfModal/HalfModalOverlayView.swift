//
//  HalfModalOverlayView.swift
//  Half-Modal-Practice
//
//  Created by 大西玲音 on 2021/08/21.
//

import UIKit

final class HalfModalOverlayView: UIView {
    
    var isActive: Bool = false {
        didSet {
            alpha = isActive ? 0.5 : 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSelf()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
    }
    
    private func setupSelf() {
        backgroundColor = .black
        alpha = 0.5
    }
    
}
