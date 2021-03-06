//
//  Goal.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import Foundation

// 共通の型
struct Category {
    let title: String
    let isExpanded: Bool
    let goals: [Goal]
    let isAchieved: Bool
    let order: Int
    let identifier: String

    struct Goal {
        let title: String
        let memo: String
        let isExpanded: Bool
        let priority: Priority
        let isChecked: Bool
        let dueDate: Date
        let createdDate: Date
        let imageData: Data?
        let order: Int
        let identifier: String

        struct Priority {
            var mark: PriorityMark
            var number: PriorityNumber
        }
    }

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

extension Category {

    init(category: Category,
         title: String? = nil,
         isExpanded: Bool? = nil,
         goals: [Category.Goal]? = nil,
         isAchieved: Bool? = nil,
         order: Int? = nil,
         identifier: String? = nil) {
        if let title = title {
            self.title = title
        } else {
            self.title = category.title
        }
        if let isExpanded = isExpanded {
            self.isExpanded = isExpanded
        } else {
            self.isExpanded = category.isExpanded
        }
        if let goals = goals {
            self.goals = goals
        } else {
            self.goals = category.goals
        }
        if let isAchieved = isAchieved {
            self.isAchieved = isAchieved
        } else {
            self.isAchieved = category.isAchieved
        }
        if let order = order {
            self.order = order
        } else {
            self.order = category.order
        }
        if let identifier = identifier {
            self.identifier = identifier
        } else {
            self.identifier = category.identifier
        }
    }

}

extension Category.Goal {

    init(goal: Category.Goal,
         title: String? = nil,
         memo: String? = nil,
         isExpanded: Bool? = nil,
         priority: Category.Goal.Priority? = nil,
         isChecked: Bool? = nil,
         dueDate: Date? = nil,
         createdDate: Date? = nil,
         imageData: Data? = nil,
         order: Int? = nil,
         identifier: String? = nil) {
        if let title = title {
            self.title = title
        } else {
            self.title = goal.title
        }
        if let memo = memo {
            self.memo = memo
        } else {
            self.memo = goal.memo
        }
        if let isExpanded = isExpanded {
            self.isExpanded = isExpanded
        } else {
            self.isExpanded = goal.isExpanded
        }
        if let priority = priority {
            self.priority = priority
        } else {
            self.priority = goal.priority
        }
        if let isChecked = isChecked {
            self.isChecked = isChecked
        } else {
            self.isChecked = goal.isChecked
        }
        if let dueDate = dueDate {
            self.dueDate = dueDate
        } else {
            self.dueDate = goal.dueDate
        }
        if let createdDate = createdDate {
            self.createdDate = createdDate
        } else {
            self.createdDate = goal.createdDate
        }
        if let imageData = imageData {
            self.imageData = imageData
        } else {
            self.imageData = goal.imageData
        }
        if let order = order {
            self.order = order
        } else {
            self.order = goal.order
        }
        if let identifier = identifier {
            self.identifier = identifier
        } else {
            self.identifier = goal.identifier
        }

    }

}
