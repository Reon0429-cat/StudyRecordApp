//
//  HUDIndicator.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import PKHUD

struct PKHUDIndicator: IndicatorProtocol {
    
    func flash(_ type: IndicatorType,
               completion: @escaping () -> Void) {
        let type = convertToHUDContentType(from: type)
        HUD.flash(type,
                  onView: nil,
                  delay: 0) { _ in
            completion()
        }
    }
    
    func show(_ type: IndicatorType) {
        let type = convertToHUDContentType(from: type)
        HUD.show(type)
    }
    
    func hide() {
        HUD.hide()
    }
    
    private func convertToHUDContentType(from type: IndicatorType) -> HUDContentType {
        switch type {
            case .progress: return .progress
            case .success: return .success
            case .error: return .error
        }
    }
    
}

