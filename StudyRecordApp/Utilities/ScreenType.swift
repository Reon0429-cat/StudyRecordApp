//
//  ScreenType.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/17.
//

import Foundation

protocol ScreenPresentationDelegate: AnyObject {
    func screenDidPresented(screenType: ScreenType)
    func scroll(sourceScreenType: ScreenType,
                destinationScreenType: ScreenType,
                completion: (() -> Void)?)
}

enum ScreenType: Int, CaseIterable {
    case record
    case goal
    case graph
    case countDown
    case setting
    
    var title: String {
        switch self {
            case .record: return "記録"
            case .goal: return "目標"
            case .graph: return "グラフ"
            case .countDown: return "カウント\nダウン"
            case .setting: return "設定"
        }
    }
}
