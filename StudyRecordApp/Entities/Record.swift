//
//  Record.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

// MARK: - ToDo Realmのプロパティを増やしたときに、リリース後に落ちる対策をする

// 共通の型
struct Record: Equatable {
    var title: String
    var histories: [History]?
    var isExpanded: Bool
    var graphColor: GraphColor
    var memo: String
    var yearID: String
    var monthID: String
    var order: Int
}

struct History: Equatable {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minutes: Int
}

struct GraphColor: Equatable {
    var redValue: CGFloat
    var greenValue: CGFloat
    var blueValue: CGFloat
    var alphaValue: CGFloat
}
