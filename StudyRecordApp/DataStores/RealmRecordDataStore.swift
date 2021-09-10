//
//  RealmRecordDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/05.
//

import RealmSwift

protocol RecordDataStoreProtocol {
    func create(record: Record)
    func read(at index: Int) -> Record
    func readAll() -> [Record]
    func update(record: Record, at index: Int)
    func delete(at index: Int)
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath)
}

final class RealmRecordDataStore: RecordDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<RecordRealm> {
        realm.objects(RecordRealm.self).sorted(byKeyPath: "order", ascending: true)
    }
    
    func create(record: Record) {
        let recordRealm = RecordRealm(record: record)
        try! realm.write {
            realm.add(recordRealm)
        }
    }
    
    func read(at index: Int) -> Record {
        return Record(record: objects[index])
    }
    
    func readAll() -> [Record] {
        return objects.map { Record(record: $0) }
    }
    
    func update(record: Record, at index: Int) {
        let object = objects[index]
        // Recordのプロパティが増えたときにコンパイルで漏れを防ぐためにインスタンスを再生成している。
        let record = Record(title: record.title,
                            histories: record.histories,
                            isExpanded: record.isExpanded,
                            graphColor: record.graphColor,
                            memo: record.memo,
                            yearID: record.yearID,
                            monthID: record.monthID,
                            order: record.order)
        try! realm.write {
            object.title = record.title
            object.histories.removeAll()
            object.histories.append(objectsIn: record.historiesList)
            object.isExpanded = record.isExpanded
            object.graphColor?.redValue = Float(record.graphColor.redValue)
            object.graphColor?.greenValue = Float(record.graphColor.greenValue)
            object.graphColor?.blueValue = Float(record.graphColor.blueValue)
            object.graphColor?.alphaValue = Float(record.graphColor.alphaValue)
            object.memo = record.memo
            object.yearID = record.yearID
            object.monthID = record.monthID
            object.order = record.order
        }
    }
    
    func delete(at index: Int) {
        let object = objects[index]
        try! realm.write {
            realm.delete(object)
            // オブジェクトを消去するとorderに抜けが生じるため、その分詰める
            for i in index..<objects.count {
                objects[i].order -= 1
            }
        }
    }
    
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath) {
        let sourceObject = objects[sourceIndexPath.row]
        let destinationObject = objects[destinationIndexPath.row]
        let destinationObjectOrder = destinationObject.order
        try! realm.write {
            if sourceIndexPath.row < destinationIndexPath.row {
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    objects[index].order -= 1
                }
            } else {
                for index in destinationIndexPath.row...sourceIndexPath.row {
                    objects[index].order += 1
                }
            }
            sourceObject.order = destinationObjectOrder
        }
    }
    
}

private extension RecordRealm {
    
    convenience init(record: Record) {
        self.init()
        // Recordのプロパティが増えたときにコンパイルで漏れを防ぐためにインスタンスを再生成している。
        let record = Record(title: record.title,
                            histories: record.histories,
                            isExpanded: record.isExpanded,
                            graphColor: record.graphColor,
                            memo: record.memo,
                            yearID: record.yearID,
                            monthID: record.monthID,
                            order: record.order)
        self.title = record.title
        self.histories = record.historiesList
        self.isExpanded = record.isExpanded
        self.graphColor?.redValue = Float(record.graphColor.redValue)
        self.graphColor?.greenValue = Float(record.graphColor.greenValue)
        self.graphColor?.blueValue = Float(record.graphColor.blueValue)
        self.graphColor?.alphaValue = Float(record.graphColor.alphaValue)
        self.memo = record.memo
        self.yearID = record.yearID
        self.monthID = record.monthID
        self.order = record.order
    }
    
}

private extension Record {
    
    init(record: RecordRealm) {
        // Recordのプロパティが増えたときにコンパイルで漏れを防ぐためにインスタンスを再生成している。
        let record = Record(title: record.title,
                            histories: record.historiesArray,
                            isExpanded: record.isExpanded,
                            graphColor: GraphColor(record: record),
                            memo: record.memo,
                            yearID: record.yearID,
                            monthID: record.monthID,
                            order: record.order)
        self.title = record.title
        self.histories = record.histories
        self.isExpanded = record.isExpanded
        self.graphColor = record.graphColor
        self.memo = record.memo
        self.yearID = record.yearID
        self.monthID = record.monthID
        self.order = record.order
    }
    
}

// [History]に変換 ->  List<HistoryRealm>
private extension Record {
    
    var historiesList: List<HistoryRealm> {
        let histories = List<HistoryRealm>()
        self.histories?.forEach { history in
            let historyRealm = HistoryRealm(history: history)
            histories.append(historyRealm)
        }
        return histories
    }
    
}

// List<HistoryRealm> -> [History]に変換
private extension RecordRealm {
    
    var historiesArray: [History] {
        var histories = [History]()
        self.histories.forEach { history in
            let history = History(history: history)
            histories.append(history)
        }
        return histories
    }
    
}
