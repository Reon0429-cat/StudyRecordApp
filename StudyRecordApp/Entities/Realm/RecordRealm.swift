//
//  RecordRealm.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import RealmSwift

// Realmに依存した型
final class RecordRealm: Object {
    @objc dynamic var title: String = ""
    var histories = List<HistoryRealm>()
    @objc dynamic var isExpanded: Bool = false
    @objc dynamic var graphColor: GraphColorRealm? = GraphColorRealm()
    @objc dynamic var memo: String = ""
    @objc dynamic var yearID: String = ""
    @objc dynamic var monthID: String = ""
    @objc dynamic var order: Int = 0
    @objc dynamic var uuidString = UUID().uuidString
    
    override class func primaryKey() -> String? {
        return "uuidString"
    }
}

final class HistoryRealm: Object {
    @objc dynamic var year: Int = 0
    @objc dynamic var month: Int = 0
    @objc dynamic var day: Int = 0
    @objc dynamic var hour: Int = 0
    @objc dynamic var minutes: Int = 0
}

final class GraphColorRealm: Object {
    @objc dynamic var redValue: Float = 0.0
    @objc dynamic var greenValue: Float = 0.0
    @objc dynamic var blueValue: Float = 0.0
    @objc dynamic var alphaValue: Float = 0.0
}

extension Record {
    
    init(record: Record) {
        self.init(title: record.title,
                  histories: record.histories,
                  isExpanded: record.isExpanded,
                  graphColor: record.graphColor,
                  memo: record.memo,
                  yearID: record.yearID,
                  monthID: record.monthID,
                  order: record.order,
                  uuidString: record.uuidString)
    }
    
}

extension UIColor {
    
    convenience init(record: Record) {
        self.init(red: record.graphColor.redValue,
                  green: record.graphColor.greenValue,
                  blue: record.graphColor.blueValue,
                  alpha: record.graphColor.alphaValue)
    }
    
}

extension GraphColor {
    
    init(record: RecordRealm) {
        self.init(redValue: CGFloat(record.graphColor?.redValue ?? 0.0),
                  greenValue: CGFloat(record.graphColor?.greenValue ?? 0.0),
                  blueValue: CGFloat(record.graphColor?.blueValue ?? 0.0),
                  alphaValue: CGFloat(record.graphColor?.alphaValue ?? 0.0))
    }
    
    init(record: Record) {
        self.init(redValue: CGFloat(record.graphColor.redValue),
                  greenValue: CGFloat(record.graphColor.greenValue),
                  blueValue: CGFloat(record.graphColor.blueValue),
                  alphaValue: CGFloat(record.graphColor.alphaValue))
    }
    
    init(color: UIColor) {
        self.init(redValue: color.redValue,
                  greenValue: color.greenValue,
                  blueValue: color.blueValue,
                  alphaValue: color.alphaValue)
    }
    
}

extension HistoryRealm {
    
    convenience init(history: History) {
        let historyRealm = HistoryRealm(value: ["year": history.year,
                                                "month": history.month,
                                                "day": history.day,
                                                "hour": history.hour,
                                                "minutes": history.minutes])
        self.init(value: historyRealm)
    }
    
}

extension History {
    
    init(history: HistoryRealm) {
        self.init(year: history.year,
                  month: history.month,
                  day: history.day,
                  hour: history.hour,
                  minutes: history.minutes)
    }
    
}
