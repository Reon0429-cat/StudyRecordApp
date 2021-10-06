//
//  RealmRecordDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/05.
//

import Foundation

protocol RealmRecordDataStoreProtocol {
    func create(record: RecordRealm)
    func readAll() -> [RecordRealm]
    func update(record: RecordRealm)
    func delete(record: RecordRealm)
    func sort(sourceObject: RecordRealm,
              destinationObject: RecordRealm)
}

final class RealmRecordDataStore: RealmRecordDataStoreProtocol {
    
    func create(record: RecordRealm) {
        RealmManager.create(object: record)
    }
    
    func readAll() -> [RecordRealm] {
        return RealmManager.readAll(type: RecordRealm.self)
    }
    
    func update(record: RecordRealm) {
        RealmManager.update(object: record)
    }
    
    func delete(record: RecordRealm) {
        RealmManager.delete(object: record,
                            identifier: record.identifier)
        RealmManager.setupOrder(type: RecordRealm.self)
    }
    
    func sort(sourceObject: RecordRealm,
              destinationObject: RecordRealm) {
        RealmManager.sort(sourceObject: sourceObject,
                          destinationObject: destinationObject)
    }
    
}

