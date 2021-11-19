//
//  RxRecordRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/11.
//

import Foundation
import RxSwift
import RealmSwift

final class RxRecordRepository: RxRecordRepositoryProtocol {
    
    private let dataStore = RealmRecordDataStore()
    
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

extension RecordRealm {
    
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

extension Record {
    
    init(record: RecordRealm) {
        self = Record(title: record.title,
                      histories: record.historiesArray,
                      isExpanded: record.isExpanded,
                      graphColor: GraphColor(record: record),
                      memo: record.memo,
                      yearID: record.yearID,
                      monthID: record.monthID,
                      order: record.order,
                      identifier: record.identifier)
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
