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
    
    private var repository: RxRecordRepositoryProtocol
    private var deleteRecordTrigger = PublishRelay<Record>()
    private var updateRecordTrigger = PublishRelay<Record>()
    private var readRecordsTrigger = PublishRelay<Void>()
    private var recordsRelay = BehaviorRelay<[Record]>(value: [])
    private let disposeBag = DisposeBag()
    var records: Observable<[Record]> {
        recordsRelay.asObservable()
    }
    
    init(repository: RxRecordRepositoryProtocol) {
        self.repository = repository
        
        deleteRecordTrigger
            .flatMapLatest(repository.delete(record:))
            .subscribe()
            .disposed(by: disposeBag)
        
        updateRecordTrigger
            .flatMapLatest(repository.update(record:))
            .subscribe()
            .disposed(by: disposeBag)
        
        readRecordsTrigger
            .flatMapLatest(repository.readAll)
            .bind(to: recordsRelay)
            .disposed(by: disposeBag)
        
    }
    
    func deleteRecord(record: Record) {
        deleteRecordTrigger.accept(record)
    }
    
    func readRecords() {
        readRecordsTrigger.accept(())
    }
    
    func updateRecord(record: Record) {
        updateRecordTrigger.accept(record)
    }
    
    func changeOpeningAndClosing(at index: Int) {
        repository.read(at: index)
            .subscribe(onSuccess: { record in
                let newRecord = Record(record: record,
                                       isExpanded: !record.isExpanded)
                self.updateRecordTrigger.accept(newRecord)
            })
            .disposed(by: disposeBag)
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
        var today = 0
        var total = 0
        repository.read(at: index)
            .subscribe(onSuccess: { record in
                today = record.histories?
                    .filter { self.isToday($0) }
                    .reduce(0) { $0 + $1.hour * 60 + $1.minutes } ?? 0
                total = record.histories?
                    .reduce(0) { $0 + $1.hour * 60 + $1.minutes } ?? 0
            })
            .disposed(by: disposeBag)
        return (today: today, total: total)
    }
    
    private func isToday(_ history: History) -> Bool {
        return Date().year == history.year
        && Date().month == history.month
        && Date().day == history.day
    }
    
}
