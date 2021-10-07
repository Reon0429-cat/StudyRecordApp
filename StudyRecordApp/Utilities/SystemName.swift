//
//  SystemName.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/06.
//

import UIKit

enum SystemName: String {
    case eyedropper
    case recordCircle = "record.circle"
    case circle
    case xmarkCircleFill = "xmark.circle.fill"
    case listBullet = "list.bullet"
    case eyeFill = "eye.fill"
    case eyeSlashFill = "eye.slash.fill"
    case envelope
    case lock
    case xmark
    case plus
    case arrowUpArrowDownCircleFill = "arrow.up.arrow.down.circle.fill"
}

extension UIImage {
    
    convenience init?(systemName: SystemName) {
        self.init(systemName: systemName.rawValue)
    }
    
}