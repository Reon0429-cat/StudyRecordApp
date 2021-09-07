//
//  UIImage+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/07.
//

import UIKit

extension UIImage {
    
    func setColor(_ color: UIColor) -> UIImage {
        let image = self.withTintColor(color,
                                       renderingMode: .alwaysOriginal)
        return image
    }
    
}

