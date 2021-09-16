//
//  PriorityStackView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/01.
//

import UIKit

final class PriorityStackView: UIStackView {
    
    convenience init(frame: CGRect = .zero,
                     priority: Priority,
                     imageSize: CGFloat = 20) {
        self.init()
        
        setup(priority: priority,
              imageSize: imageSize)
        
    }
    
    private func setup(priority: Priority,
                       imageSize: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.distribution = .fillEqually
        self.alignment = .fill
        self.spacing = 10
        self.axis = .horizontal
        (0...priority.number.rawValue).forEach { _ in
            let imageView = UIImageView()
            imageView.tintColor = .dynamicColor(light: .black, dark: .white)
            imageView.preferredSymbolConfiguration = .init(pointSize: imageSize)
            imageView.image = UIImage(systemName: priority.mark.imageName)
            self.addArrangedSubview(imageView)
        }
    }
    
}
