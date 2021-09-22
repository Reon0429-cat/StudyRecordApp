//
//  RxRecordRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/23.
//

import Foundation
import RxSwift

protocol RxRecordRepositoryProtocol {
    func create(record: Record) -> Completable
    func read(at index: Int) -> Single<Record>
    func readAll() -> Single<[Record]>
    func update(record: Record, at index: Int) -> Completable
    func delete(at index: Int) -> Completable
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath) -> Completable
}

final class RxRecordRepository: RxRecordRepositoryProtocol {
    
    private var dataStore: RecordDataStoreProtocol
    init(dataStore: RecordDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func create(record: Record) -> Completable {
        dataStore.create(record: record)
        return .empty()
    }
    
    func read(at index: Int) -> Single<Record> {
        return .just(dataStore.read(at: index))
    }
    
    func readAll() -> Single<[Record]> {
        return .just(dataStore.readAll())
    }
    
    func update(record: Record,
                at index: Int) -> Completable {
        dataStore.update(record: record, at: index)
        return .empty()
    }
    
    func delete(at index: Int) -> Completable {
        dataStore.delete(at: index)
        return .empty()
    }
    
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath) -> Completable {
        dataStore.sort(from: sourceIndexPath,
                       to: destinationIndexPath)
        return .empty()
    }
    
}
