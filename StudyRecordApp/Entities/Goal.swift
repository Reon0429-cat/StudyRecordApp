//
//  Goal.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import RealmSwift

// 共通の型
struct Goal {
    var title: String
    var category: Category
    var memo: String
    var priority: Priority
    var dueDate: Date
    var createdDate: Date
    var photoUrlString: String?
}

struct Category {
    var title: String
}

struct Priority {
    var mark: PriorityMark
    var number: PriorityNumber
}

enum PriorityMark: Int {
    case star
    case heart
    
    var imageName: String {
        switch self {
            case .star: return "star.fill"
            case .heart: return "heart.fill"
        }
    }
}

enum PriorityNumber: Int, CaseIterable {
    case one
    case two
    case three
    case four
    case five
}

// Realmに依存した型
final class GoalRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var category: CategoryRealm? = CategoryRealm()
    @objc dynamic var memo: String = ""
    @objc dynamic var priority: PriorityRealm? = PriorityRealm()
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var createdDate: Date = Date()
    @objc dynamic var photoUrlString: String?
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
