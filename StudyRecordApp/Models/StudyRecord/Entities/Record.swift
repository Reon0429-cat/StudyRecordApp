//
//  Record.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import RealmSwift

// 共通の型
struct Record {
    var title: String
    var time: Time
    var isExpanded: Bool
    var graphColor: GraphColor
    var memo: String
}

struct Time {
    var today: Int
    var total: Int
}

struct GraphColor {
    var redValue: CGFloat
    var greenValue: CGFloat
    var blueValue: CGFloat
    var alphaValue: CGFloat
}

// Realmに依存した型
final class RecordRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var time: TimeRealm? = TimeRealm()
    @objc dynamic var isExpanded: Bool = false
    @objc dynamic var graphColor: GraphColorRealm? = GraphColorRealm()
    @objc dynamic var memo: String = ""
}

final class TimeRealm: Object {
    @objc dynamic var today: Int = 0
    @objc dynamic var total: Int = 0
}

final class GraphColorRealm: Object {
    @objc dynamic var redValue: Float = 0.0
    @objc dynamic var greenValue: Float = 0.0
    @objc dynamic var blueValue: Float = 0.0
    @objc dynamic var alphaValue: Float = 0.0
}
