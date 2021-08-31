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
    var image: UIImage
    var dueDate: Date
    var createdDate: Date
}

struct Category {
    
}

struct Priority {
    var mark: PriorityMark
    var number: PriorityNumber
}

enum PriorityMark: Int {
    case star
    case heart
    
    var image: UIImage {
        switch self {
            case .star:
                return UIImage(systemName: "star.fill")!
            case .heart:
                return UIImage(systemName: "heart.fill")!
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
    @objc dynamic var category: RealmCategory = RealmCategory()
    @objc dynamic var memo: String = ""
    @objc dynamic var priority: RealmPriority = RealmPriority()
    @objc dynamic var image: UIImage = UIImage()
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var createdDate: Date = Date()
}

final class RealmCategory: Object {
    
}

final class RealmPriority: Object {
    @objc dynamic private var markRawValue = 0
    var mark: PriorityMark? {
        get {
            return PriorityMark(rawValue: markRawValue)
        }
        set {
            markRawValue = newValue?.rawValue ?? 0
        }
    }
    @objc dynamic private var numberRawValue = 0
    var number: PriorityNumber? {
        get {
            return PriorityNumber(rawValue: numberRawValue)
        }
        set {
            numberRawValue = newValue?.rawValue ?? 0
        }
    }
}
