//
//  Indicator.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/30.
//

import Foundation
import PKHUD

struct Indicator {
    
    func flash(_ type: HUDContentType,
                  completion: @escaping () -> Void) {
        HUD.flash(type,
                  onView: nil,
                  delay: 0) { _ in
            completion()
        }
    }
    
    func show(_ type: HUDContentType) {
        HUD.show(type)
    }
    
    func hide() {
        HUD.hide()
    }
    
}
