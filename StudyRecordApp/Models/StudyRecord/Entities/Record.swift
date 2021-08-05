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
    var memo: String
}

struct Time {
    var today: Int
    var total: Int
}

// Realmに依存した型
final class RecordRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var time: TimeRealm? = TimeRealm()
    @objc dynamic var isExpanded: Bool = false
    @objc dynamic var memo: String = ""
}

final class TimeRealm: Object {
    @objc dynamic var today: Int = 0
    @objc dynamic var total: Int = 0
}
