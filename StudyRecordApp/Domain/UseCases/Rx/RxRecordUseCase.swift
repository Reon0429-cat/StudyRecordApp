//
//  RxRecordUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/11.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class RxRecordUseCase {

    private let repository: RxRecordRepositoryProtocol

    init(repository: RxRecordRepositoryProtocol) {
        self.repository = repository
    }

    func createRecord(record: Record) -> Completable {
        repository.create(record: record)
    }

    func deleteRecord(record: Record) -> Completable {
        repository.delete(record: record)
    }

    func readRecords() -> Single<[Record]> {
        repository.readAll()
    }

    func updateRecord(record: Record) -> Completable {
        repository.update(record: record)
    }

    func changeOpeningAndClosing(record: Record) -> Completable {
        let newRecord = Record(record: record,
                               isExpanded: !record.isExpanded)
        return repository.update(record: newRecord)
    }

    func getStudyTime(record: Record) -> (todayText: String, totalText: String) {
        let studyTime = calculateStudyTime(record: record)
        let studyTimeText = convertToStudyTimeText(from: studyTime)
        return studyTimeText
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

    private func calculateStudyTime(record: Record) -> (today: Int, total: Int) {
        let today = record.histories?
            .filter { self.isToday($0) }
            .reduce(0) { $0 + $1.hour * 60 + $1.minutes } ?? 0
        let total = record.histories?
            .reduce(0) { $0 + $1.hour * 60 + $1.minutes } ?? 0
        return (today: today, total: total)
    }

    private func isToday(_ history: History) -> Bool {
        return Date().year == history.year
            && Date().month == history.month
            && Date().day == history.day
    }

}
