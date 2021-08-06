//
//  RecordUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/05.
//

import Foundation

final class RecordUseCase {
    
    private let repository: RecordRepositoryProtocol
    init(repository: RecordRepositoryProtocol) {
        self.repository = repository
    }
    
    var records: [Record] {
        return repository.readAll()
    }
    
    func changeOpeningAndClosing(at index: Int) {
        let record = repository.read(at: index)
        let newRecord = Record(title: record.title,
                               time: record.time,
                               isExpanded: !record.isExpanded,
                               graphColor: record.graphColor,
                               memo: record.memo)
        repository.update(record: newRecord, at: index)
    }
    
    func save(record: Record) {
        repository.create(record: record)
    }
    
}
