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
}

final class RecordDataStore: RecordDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<RecordRealm> {
        realm.objects(RecordRealm.self)
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
                            time: record.time,
                            isExpanded: record.isExpanded,
                            graphColor: record.graphColor,
                            memo: record.memo)
        try! realm.write {
            object.title = record.title
            object.time?.today = record.time.today
            object.time?.total = record.time.total
            object.isExpanded = record.isExpanded
            object.graphColor?.redValue = Float(record.graphColor.redValue)
            object.graphColor?.greenValue = Float(record.graphColor.greenValue)
            object.graphColor?.blueValue = Float(record.graphColor.blueValue)
            object.graphColor?.alphaValue = Float(record.graphColor.alphaValue)
            object.memo = record.memo
        }
    }
    
    func delete(at index: Int) {
        let object = objects[index]
        try! realm.write {
            realm.delete(object)
        }
    }
    
}

private extension RecordRealm {
    
    convenience init(record: Record) {
        self.init()
        // Recordのプロパティが増えたときにコンパイルで漏れを防ぐためにインスタンスを再生成している。
        let record = Record(title: record.title,
                            time: record.time,
                            isExpanded: record.isExpanded,
                            graphColor: record.graphColor,
                            memo: record.memo)
        self.title = record.title
        self.time?.today = record.time.today
        self.time?.total = record.time.total
        self.isExpanded = record.isExpanded
        self.graphColor?.redValue = Float(record.graphColor.redValue)
        self.graphColor?.greenValue = Float(record.graphColor.greenValue)
        self.graphColor?.blueValue = Float(record.graphColor.blueValue)
        self.graphColor?.alphaValue = Float(record.graphColor.alphaValue)
        self.memo = record.memo
    }
    
}

private extension Record {
    
    init(record: RecordRealm) {
        // Recordのプロパティが増えたときにコンパイルで漏れを防ぐためにインスタンスを再生成している。
        let record = Record(title: record.title,
                            time: Time(today: record.time?.today ?? 0,
                                       total: record.time?.total ?? 0),
                            isExpanded: record.isExpanded,
                            graphColor: GraphColor(redValue: CGFloat(record.graphColor?.redValue ?? 0.0),
                                                   greenValue: CGFloat(record.graphColor?.greenValue ?? 0.0),
                                                   blueValue: CGFloat(record.graphColor?.blueValue ?? 0.0),
                                                   alphaValue: CGFloat(record.graphColor?.alphaValue ?? 0.0)),
                            memo: record.memo)
        self.title = record.title
        self.time = record.time
        self.isExpanded = record.isExpanded
        self.graphColor = record.graphColor
        self.memo = record.memo
    }
    
}
