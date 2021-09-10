//
//  GoalRealm.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import RealmSwift

// Realmに依存した型
final class GoalRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var category: CategoryRealm? = CategoryRealm()
    @objc dynamic var memo: String = ""
    @objc dynamic var priority: PriorityRealm? = PriorityRealm()
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var createdDate: Date = Date()
    @objc dynamic var imageData: Data?
}

final class CategoryRealm: Object {
    @objc dynamic var title: String = ""
}

final class PriorityRealm: Object {
    @objc private dynamic var markRawValue = 0
    var mark: PriorityMark {
        get {
            return PriorityMark(rawValue: markRawValue) ?? .star
        }
        set {
            markRawValue = newValue.rawValue
        }
    }
    @objc private dynamic var numberRawValue = 0
    var number: PriorityNumber {
        get {
            return PriorityNumber(rawValue: numberRawValue) ?? .one
        }
        set {
            numberRawValue = newValue.rawValue
        }
    }
}
