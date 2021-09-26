//
//  RecordRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/05.
//

import Foundation

protocol RecordRepositoryProtocol {
    func create(record: Record)
    func read(at index: Int) -> Record
    func readAll() -> [Record]
    func update(record: Record)
    func delete(record: Record)
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath)
}

final class RecordRepository: RecordRepositoryProtocol {
    
    private var dataStore: RecordDataStoreProtocol
    init(dataStore: RecordDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func create(record: Record) {
        dataStore.create(record: record)
    }
    
    func read(at index: Int) -> Record {
        return dataStore.readAll()[index]
    }
    
    func readAll() -> [Record] {
        return dataStore.readAll()
    }
    
    func update(record: Record) {
        dataStore.update(record: record) 
    }
    
    func delete(record: Record) {
        dataStore.delete(record: record)
    }
    
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath) {
        dataStore.sort(from: sourceIndexPath,
                       to: destinationIndexPath)
    }
    
}
