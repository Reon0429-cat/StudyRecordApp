//
//  CustomSegmentedControl.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/07.
//

import UIKit

final class CustomSegmentedControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setObserver()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        setObserver()
        
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedThemeColor),
                                               name: .changedThemeColor,
                                               object: nil)
    }
    
    @objc
    private func changedThemeColor() {
        setupColor()
    }
    
    private func setup() {
        setupColor()
    }
    
    private func setupColor() {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                    UIColor.dynamicColor(light: .black,
                                                         dark: .white)],
                               for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                               for: .selected)
        selectedSegmentTintColor = .accentColor ?? .black
    }
    
    func create(_ titles: [String], selectedIndex: Int) {
        removeAllSegments()
        titles.enumerated().forEach { index, title in
            insertSegment(withTitle: title,
                          at: index,
                          animated: false)
        }
        selectedSegmentIndex = selectedIndex
    }
    
    func setImages(_ images: [UIImage], selectedIndex: Int) {
        removeAllSegments()
        images.enumerated().forEach { index, image in
            insertSegment(with: image, at: index, animated: false)
        }
        selectedSegmentIndex = selectedIndex
    }
    
}
