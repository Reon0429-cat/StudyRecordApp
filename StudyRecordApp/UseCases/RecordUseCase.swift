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
                               order: record.order,
                               identifier: record.identifier)
        repository.update(record: newRecord)
    }
    
    func save(record: Record) {
        repository.create(record: record)
    }
    
    func delete(record: Record) {
        repository.delete(record: record)
    }
    
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath) {
        repository.sort(from: sourceIndexPath,
                        to: destinationIndexPath)
    }
    
    func update(record: Record) {
        repository.update(record: record)
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
    
    func getStudyTime(at index: Int) -> (todayText: String,
                                         totalText: String) {
        let studyTime = calculateStudyTime(at: index)
        let studyTimeText = convertToStudyTimeText(from: studyTime)
        return studyTimeText
    }
    
    func validateGraphData(oldRecords: [Record]?) -> (indexPaths: [IndexPath],
                                                      shouldReloadAll: Bool) {
        guard let oldRecords = oldRecords,
              records.count == oldRecords.count else { return (indexPaths: [],
                                                               shouldReloadAll: true) }
        var indexPaths = [IndexPath]()
        for (index, record) in records.enumerated() {
            if oldRecords[index].histories != record.histories
                || oldRecords[index].graphColor != record.graphColor
                || oldRecords[index].title != record.title
                || record.order != oldRecords[index].order {
                indexPaths.append(IndexPath(row: index, section: 0))
            }
        }
        return (indexPaths: indexPaths,
                shouldReloadAll: false)
    }
    
    private func convertToStudyTimeText(from studyTime: (today: Int,
                                                         total: Int)) -> (todayText: String,
                                                                          totalText: String) {
        let todayLocalizedText = L10n.today
        let totalLocalizedText = L10n.total
        let hourLocalizedText = L10n.shortHour
        let minuteLocalizedText = L10n.shortMinute
        let todayText: String = {
            if studyTime.today >= 60 {
                return todayLocalizedText + ": " + "\(studyTime.today / 60) " + hourLocalizedText
            }
            return todayLocalizedText + ": " + "\(studyTime.today) " + minuteLocalizedText
        }()
        let totalText: String = {
            if studyTime.total >= 60 {
                return totalLocalizedText + ": " + "\(studyTime.total / 60) " + hourLocalizedText
            }
            return totalLocalizedText + ": " + "\(studyTime.total) " + minuteLocalizedText
        }()
        return (todayText: todayText, totalText: totalText)
    }
    
    private func calculateStudyTime(at index: Int) -> (today: Int, total: Int) {
        let record = repository.read(at: index)
        let today = record.histories?
            .filter { isToday($0) }
            .reduce(0) { $0 + $1.hour * 60 + $1.minutes } ?? 0
        let total = record.histories?
            .reduce(0) { $0 + $1.hour * 60 + $1.minutes } ?? 0
        return (today, total)
    }
    
    private func isToday(_ history: History) -> Bool {
        return Date().year == history.year
        && Date().month == history.month
        && Date().day == history.day
    }
    
}
