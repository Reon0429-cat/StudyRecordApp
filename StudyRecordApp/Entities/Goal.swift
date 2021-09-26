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
    let identifier: String
    
    struct Goal {
        var title: String
        var memo: String
        var isExpanded: Bool
        var priority: Priority
        var dueDate: Date
        var createdDate: Date
        var imageData: Data?
        
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
