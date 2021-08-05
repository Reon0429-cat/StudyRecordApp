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
        let title = record.title
        let time = record.time
        let isExpanded = !record.isExpanded
        let memo = record.memo
        let newRecord = Record(title: title, time: time, isExpanded: isExpanded, memo: memo)
        repository.update(record: newRecord, at: index)
    }
    
    func save(record: Record) {
        repository.create(record: record)
    }
    
}
