//
//  CustomTextField.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/14.
//

import UIKit

final class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
    }
    
    func setup() {
        tintColor = .dynamicColor(light: .black,
                                  dark: .white)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setUnderLine()
        }
    }
    
}
