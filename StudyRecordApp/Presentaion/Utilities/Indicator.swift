//
//  Indicator.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/30.
//

import Foundation

enum IndicatorType {
    case progress
    case success
    case error
}

protocol IndicatorProtocol {
    func flash(_ type: IndicatorType,
               completion: @escaping () -> Void)
    func show(_ type: IndicatorType)
    func hide()
}

struct Indicator {
    
    private let indicator: IndicatorProtocol
    init(kinds indicator: IndicatorProtocol) {
        self.indicator = indicator
    }
    
    func flash(_ type: IndicatorType,
               completion: @escaping () -> Void) {
        indicator.flash(type, completion: completion)
    }
    
    func show(_ type: IndicatorType) {
        indicator.show(type)
    }
    
    func hide() {
        indicator.hide()
    }
    
}
