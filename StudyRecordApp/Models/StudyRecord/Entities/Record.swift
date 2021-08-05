//
//  Record.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import RealmSwift



final class Record: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var time: Time? = Time()
    @objc dynamic var expanded: Bool = false
    @objc dynamic var memo: String = ""
}

final class Time: Object {
    @objc dynamic var today: Int = 0
    @objc dynamic var total: Int = 0
}
