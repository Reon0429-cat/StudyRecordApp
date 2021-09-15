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
    
    func getStudyTime(at index: Int) -> (todayText: String,
                                         totalText: String) {
        let studyTime = calculateStudyTime(at: index)
        let studyTimeText = convertToStudyTimeText(from: studyTime)
        return studyTimeText
    }
    
    private func convertToStudyTimeText(from studyTime: (today: Int,
                                                         total: Int)) -> (todayText: String,
                                                                          totalText: String) {
        let todayLocalizedText = LocalizeKey.today.localizedString()
        let totalLocalizedText = LocalizeKey.total.localizedString()
        let hourLocalizedText = LocalizeKey.shortHour.localizedString()
        let minuteLocalizedText = LocalizeKey.shortMinute.localizedString()
        let todayText: String = {
            if studyTime.today >= 60 {
                return todayLocalizedText + ": " + "\(studyTime.today / 60) " + hourLocalizedText
            }
            return todayLocalizedText + ": " + "\(studyTime.today / 60) " + minuteLocalizedText
        }()
        let totalText: String = {
            if studyTime.total >= 60 {
                return totalLocalizedText + ": " + "\(studyTime.total / 60) " + hourLocalizedText
            }
            return totalLocalizedText + ": " + "\(studyTime.total / 60) " + minuteLocalizedText
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
        // MARK: - ToDo ローカライズする
        let historyDate = "\(history.year)年\(history.month)月\(history.day)日"
        let today = Converter.convertToString(from: Date(), format: "yyyy年M月d日")
        return historyDate == today
    }
    
}
