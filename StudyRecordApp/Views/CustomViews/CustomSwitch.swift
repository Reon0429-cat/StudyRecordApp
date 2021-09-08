//
//  CustomSwitch.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/08.
//

import UIKit

final class CustomSwitch: UISwitch {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
    }
    
    func setup() {
        thumbTintColor = .white
        backgroundColor = .black
        onTintColor = .clear
    }
    
}

