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
        try! realm.write {
            object.title = record.title
            object.time?.today = record.time.today
            object.time?.total = record.time.total
            object.isExpanded = record.isExpanded
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
        self.title = record.title
        self.time?.today = record.time.today
        self.time?.total = record.time.total
        self.isExpanded = record.isExpanded
        self.memo = record.memo
    }
    
}

private extension Record {
    
    init(record: RecordRealm) {
        self.title = record.title
        self.time = Time(today: 0, total: 0)
        self.time.today = record.time?.today ?? 0
        self.time.total = record.time?.total ?? 0
        self.isExpanded = record.isExpanded
        self.memo = record.memo
    }
    
}
