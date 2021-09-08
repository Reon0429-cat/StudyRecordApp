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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
    }
    
    func setup() {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                               for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                               for: .selected)
        selectedSegmentTintColor = .black
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
    
}
