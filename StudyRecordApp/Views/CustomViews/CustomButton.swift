//
//  CustomButton.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/13.
//

import UIKit

final class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
    }
    
    func setup() {
        setGradation(colors: [.gray, .black],
                     locations: [0.1, 0.9])
        layer.cornerRadius = 10
    }
    
    func changeState(isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.layer.opacity = isEnabled ? 1 : 0.8
    }
    
}

