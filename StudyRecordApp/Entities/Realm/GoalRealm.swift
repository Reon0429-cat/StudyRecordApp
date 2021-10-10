//
//  GoalRealm.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import RealmSwift

// Realmに依存した型
final class CategoryRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isExpanded: Bool = false
    var goals = List<GoalRealm>()
    @objc private dynamic var listRawValue = 0
    var listType: ListType {
        get { return ListType(rawValue: listRawValue) ?? .category }
        set { listRawValue = newValue.rawValue }
    }
    @objc dynamic var order: Int = 0
    @objc dynamic var identifier = UUID().uuidString
    
    override class func primaryKey() -> String? {
        return "identifier"
    }
}

final class GoalRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var memo: String = ""
    @objc dynamic var isExpanded: Bool = false
    @objc dynamic var priority: PriorityRealm? = PriorityRealm()
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var createdDate: Date = Date()
    @objc dynamic var imageData: Data?
    @objc dynamic var order: Int = 0
    @objc dynamic var identifier = UUID().uuidString
    
    override class func primaryKey() -> String? {
        return "identifier"
    }
}

final class PriorityRealm: Object {
    @objc private dynamic var markRawValue = 0
    var mark: PriorityMark {
        get { return PriorityMark(rawValue: markRawValue) ?? .star }
        set { markRawValue = newValue.rawValue }
    }
    @objc private dynamic var numberRawValue = 0
    var number: PriorityNumber {
        get { return PriorityNumber(rawValue: numberRawValue) ?? .one }
        set { numberRawValue = newValue.rawValue }
    }
}
