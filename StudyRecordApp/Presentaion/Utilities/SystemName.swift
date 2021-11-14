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
    case plusCircle = "plus.circle"
    case arrowUpArrowDownCircleFill = "arrow.up.arrow.down.circle.fill"
    case arrowUpArrowDown = "arrow.up.arrow.down"
    case xmarkCircle = "xmark.circle"
    case arrowtriangleDownFill = "arrowtriangle.down.fill"
    case arrowtriangleUpfill = "arrowtriangle.up.fill"
    case checkmarkCircleFill = "checkmark.circle.fill"
    case pencil
    case flag
    case trash
    case flagSlash = "flag.slash"

    case paintPaletteFill = "paintpalette.fill"
    case circleRightHalfFilled = "circle.righthalf.filled"
    case keyFill = "key.fill"
    case globe
    case starFill = "star.fill"
    case squareAndArrowUp = "square.and.arrow.up"
    case docText = "doc.text"
    case circleHexagongridFill = "circle.hexagongrid.fill"
    case icloudAndArrowUp = "icloud.and.arrow.up"
    case lockDoc = "lock.doc"
    case personTextRectangle = "person.text.rectangle"
    case checkerboardShield = "checkerboard.shield"
}

extension UIImage {

    convenience init(systemName: SystemName) {
        self.init(systemName: systemName.rawValue)!
    }

}
