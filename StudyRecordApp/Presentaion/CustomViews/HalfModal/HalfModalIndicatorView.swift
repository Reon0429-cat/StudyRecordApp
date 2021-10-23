//
//  HalfModalIndicatorView.swift
//  Half-Modal-Practice
//
//  Created by 大西玲音 on 2021/08/21.
//

import UIKit

final class HalfModalIndicatorView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSelf()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
    }
    
    private func setupSelf() {
        layer.masksToBounds = true
        layer.cornerRadius = 5
        backgroundColor = .lightGray
    }
    
}
