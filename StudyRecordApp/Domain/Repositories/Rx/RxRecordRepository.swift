//
//  RxRecordRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/11.
//

import Foundation
import RxSwift

protocol RxRecordRepositoryProtocol {
    func create(record: Record) -> Completable
    func readAll() -> Single<[Record]>
    func read(at index: Int) -> Single<Record>
    func update(record: Record) -> Completable
    func delete(record: Record) -> Completable
    func sort(sourceObject: Record,
              destinationObject: Record) -> Completable
}

final class RxRecordRepository: RxRecordRepositoryProtocol {

    private var dataStore: RealmRecordDataStoreProtocol
    init(dataStore: RealmRecordDataStoreProtocol) {
        self.dataStore = dataStore
    }

    func create(record: Record) -> Completable {
        dataStore.create(record: RecordRealm(record: record))
        return .empty()
    }

    func readAll() -> Single<[Record]> {
        .just(dataStore.readAll().map { Record(record: $0) })
    }

    func read(at index: Int) -> Single<Record> {
        let record = dataStore.readAll()[index]
        return .just(Record(record: record))
    }

    func update(record: Record) -> Completable {
        dataStore.update(record: RecordRealm(record: record))
        return .empty()
    }

    func delete(record: Record) -> Completable {
        dataStore.delete(record: RecordRealm(record: record))
        return .empty()
    }

    func sort(sourceObject: Record,
              destinationObject: Record) -> Completable {
        let sourceRealmObject = RecordRealm(record: sourceObject)
        let destinationRealmObject = RecordRealm(record: destinationObject)
        dataStore.sort(sourceObject: sourceRealmObject,
                       destinationObject: destinationRealmObject)
        return .empty()
    }

}
