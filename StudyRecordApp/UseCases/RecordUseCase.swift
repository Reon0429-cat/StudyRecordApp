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
        repository.readAll()
    }
    
    func changeOpeningAndClosing(at index: Int) {
        let record = repository.read(at: index)
        let newRecord = Record(title: record.title,
                               histories: record.histories,
                               isExpanded: !record.isExpanded,
                               graphColor: record.graphColor,
                               memo: record.memo,
                               yearID: record.yearID,
                               monthID: record.monthID,
                               order: record.order)
        repository.update(record: newRecord, at: index)
    }
    
    func save(record: Record) {
        repository.create(record: record)
    }
    
    func delete(at index: Int) {
        repository.delete(at: index)
    }
    
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath) {
        repository.sort(from: sourceIndexPath,
                        to: destinationIndexPath)
    }
    
    func update(record: Record, at index: Int) {
        repository.update(record: record, at: index)
    }
    
    func read(at index: Int) -> Record {
        repository.read(at: index)
    }
    
    func sorted(histories: [History], at index: Int) -> [History] {
        let histories = histories.sorted {
            if $0.year == $1.year {
                if $0.month == $1.month {
                    return $0.day > $1.day
                }
                return $0.month > $1.month
            }
            return $0.year > $1.year
        }
        return histories
    }
    
}
