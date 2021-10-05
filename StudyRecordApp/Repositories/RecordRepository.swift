//
//  RecordRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/05.
//

import Foundation
import RealmSwift

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
    
    private var dataStore: RealmRecordDataStoreProtocol
    init(dataStore: RealmRecordDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func create(record: Record) {
        let recordRealm = RecordRealm(record: record)
        dataStore.create(record: recordRealm)
    }
    
    func read(at index: Int) -> Record {
        let record = Record(record: dataStore.readAll()[index])
        return record
    }
    
    func readAll() -> [Record] {
        let records = dataStore.readAll().map { Record(record: $0) }
        return records
    }
    
    func update(record: Record) {
        let recordRealm = RecordRealm(record: record)
        dataStore.update(record: recordRealm)
    }
    
    func delete(record: Record) {
        let recordRealm = RecordRealm(record: record)
        dataStore.delete(record: recordRealm)
    }
    
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath) {
        dataStore.sort(from: sourceIndexPath,
                       to: destinationIndexPath)
    }
    
}

private extension RecordRealm {
    
    convenience init(record: Record) {
        self.init()
        // Recordのプロパティが増えたときにコンパイルで漏れを防ぐためにインスタンスを再生成している。
        let record = Record(title: record.title,
                            histories: record.histories,
                            isExpanded: record.isExpanded,
                            graphColor: record.graphColor,
                            memo: record.memo,
                            yearID: record.yearID,
                            monthID: record.monthID,
                            order: record.order,
                            identifier: record.identifier)
        self.title = record.title
        self.histories = record.historiesList
        self.isExpanded = record.isExpanded
        self.graphColor?.redValue = Float(record.graphColor.redValue)
        self.graphColor?.greenValue = Float(record.graphColor.greenValue)
        self.graphColor?.blueValue = Float(record.graphColor.blueValue)
        self.graphColor?.alphaValue = Float(record.graphColor.alphaValue)
        self.memo = record.memo
        self.yearID = record.yearID
        self.monthID = record.monthID
        self.order = record.order
        self.identifier = record.identifier
    }
    
}

private extension Record {
    
    init(record: RecordRealm) {
        // Recordのプロパティが増えたときにコンパイルで漏れを防ぐためにインスタンスを再生成している。
        let record = Record(title: record.title,
                            histories: record.historiesArray,
                            isExpanded: record.isExpanded,
                            graphColor: GraphColor(record: record),
                            memo: record.memo,
                            yearID: record.yearID,
                            monthID: record.monthID,
                            order: record.order,
                            identifier: record.identifier)
        self.title = record.title
        self.histories = record.histories
        self.isExpanded = record.isExpanded
        self.graphColor = record.graphColor
        self.memo = record.memo
        self.yearID = record.yearID
        self.monthID = record.monthID
        self.order = record.order
        self.identifier = record.identifier
    }
    
}

// [History]に変換 ->  List<HistoryRealm>
private extension Record {
    
    var historiesList: List<HistoryRealm> {
        let histories = List<HistoryRealm>()
        self.histories?.forEach { history in
            let historyRealm = HistoryRealm(history: history)
            histories.append(historyRealm)
        }
        return histories
    }
    
}

// List<HistoryRealm> -> [History]に変換
private extension RecordRealm {
    
    var historiesArray: [History] {
        var histories = [History]()
        self.histories.forEach { history in
            let history = History(history: history)
            histories.append(history)
        }
        return histories
    }
    
}
