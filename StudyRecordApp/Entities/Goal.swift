//
//  Goal.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

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
