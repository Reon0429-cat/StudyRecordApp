//
//  RealmRecordDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/05.
//

import RealmSwift

protocol RealmRecordDataStoreProtocol {
    func create(record: RecordRealm)
    func readAll() -> [RecordRealm]
    func update(record: RecordRealm)
    func delete(record: RecordRealm)
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath)
}

final class RealmRecordDataStore: RealmRecordDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<RecordRealm> {
        realm.objects(RecordRealm.self).sorted(byKeyPath: "order", ascending: true)
    }
    
    func create(record: RecordRealm) {
        try! realm.write {
            realm.add(record)
        }
    }
    
    func readAll() -> [RecordRealm] {
        return objects.map { $0 }
    }
    
    func update(record: RecordRealm) {
        try! realm.write {
            realm.add(record, update: .modified)
        }
    }
    
    func delete(record: RecordRealm) {
        let object = realm.object(ofType: RecordRealm.self,
                                  forPrimaryKey: record.identifier) ?? RecordRealm()
        try! realm.write {
            realm.delete(object)
            objects
                .filter { record.order <= $0.order }
                .forEach { $0.order -= 1 }
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

