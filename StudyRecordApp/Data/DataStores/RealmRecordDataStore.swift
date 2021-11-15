//
//  RealmRecordDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/05.
//

import Foundation

final class RealmRecordDataStore {

    func create(record: RecordRealm) {
        RealmManager().create(object: record)
    }

    func readAll() -> [RecordRealm] {
        return RealmManager().readAll(type: RecordRealm.self)
    }

    func update(record: RecordRealm) {
        RealmManager().update(object: record)
    }

    func delete(record: RecordRealm) {
        RealmManager().delete(object: record)
    }

    func sort(sourceObject: RecordRealm,
              destinationObject: RecordRealm) {
        RealmManager().sort(sourceObject: sourceObject,
                            destinationObject: destinationObject)
    }

}
