//
//  RxRecordUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/23.
//

import Foundation
import RxSwift
import RxRelay

final class RxRecordUseCase {
    
    private let repository: RxRecordRepositoryProtocol
    init(repository: RxRecordRepositoryProtocol) {
        self.repository = repository
        setupBindings()
    }
    
    private let disposeBag = DisposeBag()
    private let saveRecordTrigger = PublishRelay<Record>()
    private let readRecordsTrigger = PublishRelay<Void>()
    private let updateRecordTrigger = PublishRelay<(Record, Int)>()
    private let deleteRecordTrigger = PublishRelay<Int>()
    private let sortRecordTrigger = PublishRelay<(IndexPath, IndexPath)>()
    
    var records: Observable<[Record]?> {
        recordsRelay.asObservable()
    }
    private let recordsRelay = BehaviorRelay<[Record]?>(value: nil)
    
    private func setupBindings() {
        saveRecordTrigger
            .flatMapLatest(repository.create(record:))
            .subscribe()
            .disposed(by: disposeBag)
        
        readRecordsTrigger
            .flatMapLatest(repository.readAll)
            .bind(to: recordsRelay)
            .disposed(by: disposeBag)
        
        updateRecordTrigger
            .flatMapLatest { record, index in
                self.repository.update(record: record, at: index)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        deleteRecordTrigger
            .flatMapLatest(repository.delete(at:))
            .subscribe()
            .disposed(by: disposeBag)
        
        sortRecordTrigger
            .flatMapLatest { sourceIndexPath, destinationIndexPath in
                self.repository.sort(from: sourceIndexPath,
                                     to: destinationIndexPath)
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func changeOpeningAndClosing(at index: Int) {
        repository.read(at: index)
            .subscribe(onSuccess: { record in
                let newRecord = Record(title: record.title,
                                       histories: record.histories,
                                       isExpanded: !record.isExpanded,
                                       graphColor: record.graphColor,
                                       memo: record.memo,
                                       yearID: record.yearID,
                                       monthID: record.monthID,
                                       order: record.order)
                self.updateRecordTrigger.accept((newRecord, index))
            })
            .disposed(by: disposeBag)
    }
    
    func save(record: Record) {
        saveRecordTrigger.accept(record)
    }
    
    func delete(at index: Int) {
        deleteRecordTrigger.accept(index)
    }
    
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath) {
        sortRecordTrigger.accept((sourceIndexPath,
                                  destinationIndexPath))
    }
    
    func update(record: Record, at index: Int) {
        updateRecordTrigger.accept((record, index))
    }
    
    func readAll() {
        readRecordsTrigger.accept(())
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
        // MARK: - ToDo ローカライズする
        let historyDate = "\(history.year)年\(history.month)月\(history.day)日"
        let today = Converter.convertToString(from: Date(), format: "yyyy年M月d日")
        return historyDate == today
    }
    
}
