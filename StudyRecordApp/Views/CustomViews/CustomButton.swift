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
        setGradation()
        layer.cornerRadius = 10
    }
    
}

