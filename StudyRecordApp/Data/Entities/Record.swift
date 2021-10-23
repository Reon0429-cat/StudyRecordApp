//
//  Record.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

// MARK: - ToDo Realmのプロパティを増やしたときに、リリース後に落ちる対策をする
// -> Sirenというライブラリを用いて強制アップデートさせる

// 共通の型
struct Record: Equatable {
    var title: String
    var histories: [History]?
    var isExpanded: Bool
    var graphColor: GraphColor
    var memo: String
    var yearID: String
    var monthID: String
    var order: Int
    var identifier: String
}

struct History: Equatable {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minutes: Int
}

struct GraphColor: Equatable {
    var redValue: CGFloat
    var greenValue: CGFloat
    var blueValue: CGFloat
    var alphaValue: CGFloat
}

extension Record {
    
    init(record: Record,
         title: String? = nil,
         histories: [History]? = nil,
         isExpanded: Bool? = nil,
         graphColor: GraphColor? = nil,
         memo: String? = nil,
         yearID: String? = nil,
         monthID: String? = nil,
         order: Int? = nil,
         identifier: String? = nil) {
        if let title = title {
            self.title = title
        } else {
            self.title = record.title
        }
        if let histories = histories {
            self.histories = histories
        } else {
            self.histories = record.histories
        }
        if let isExpanded = isExpanded {
            self.isExpanded = isExpanded
        } else {
            self.isExpanded = record.isExpanded
        }
        if let graphColor = graphColor {
            self.graphColor = graphColor
        } else {
            self.graphColor = record.graphColor
        }
        if let memo = memo {
            self.memo = memo
        } else {
            self.memo = record.memo
        }
        if let yearID = yearID {
            self.yearID = yearID
        } else {
            self.yearID = record.yearID
        }
        if let monthID = monthID {
            self.monthID = monthID
        } else {
            self.monthID = record.monthID
        }
        if let order = order {
            self.order = order
        } else {
            self.order = record.order
        }
        if let identifier = identifier {
            self.identifier = identifier
        } else {
            self.identifier = record.identifier
        }
    }
    
}
