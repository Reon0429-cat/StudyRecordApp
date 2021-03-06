//
//  NotificationName+Extension.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/12.
//

import Foundation

extension Notification.Name {

    static let themeColor = Notification.Name("themeColor")
    static let initTileView = Notification.Name("initTileView")
    static let graphSaveButtonDidTappped = Notification.Name("graphSaveButtonDidTappped")
    static let brightnessDidChanged = Notification.Name("BrightnessDidChanged")
    static let changedThemeColor = Notification.Name("changedThemeColor")
    static let reloadLocalData = Notification.Name("reloadLocalData")
    static let recordAdded = Notification.Name("recordAdded")

}
