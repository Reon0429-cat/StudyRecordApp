//
//  StudyRecordViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/11.
//

import Foundation
import RxSwift
import RxCocoa

protocol StudyRecordViewModelInput {
    func viewWillAppear()
    func baseViewTapDidRecognized(row: Int)
    func baseViewLongPressDidRecognized()
    func memoButtonDidTapped(row: Int, tableView: UITableView)
    func deleteButtonDidTappped(row: Int)
    func recordDeleteAlertDeleteButtonDidTapped(row: Int)
}

protocol StudyRecordViewModelOutput: AnyObject {
    var event: Driver<StudyRecordViewModel.Event> { get }
    var items: Observable<[StudyRecordViewModel.Item]> { get }
    var isHiddenTableView: Driver<Bool> { get }
}

protocol StudyRecordViewModelType {
    var inputs: StudyRecordViewModelInput { get }
    var outputs: StudyRecordViewModelOutput { get }
}

final class StudyRecordViewModel {
    
    private let recordUseCase = RxRecordUseCase(
        repository: RxRecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private let eventRelay = PublishRelay<Event>()
    private let isHiddenTableViewRelay = PublishRelay<Bool>()
    private let itemRelay = BehaviorRelay<[Item]>(value: [])
    private var records: [Record] {
        itemRelay.value.map { $0.record }
    }
    private let disposeBag = DisposeBag()
    
    init() {
        recordUseCase.readRecords()
        recordUseCase.records
            .subscribe(onNext: { records in
                self.itemRelay.accept(self.convertToItems(records: records))
            })
            .disposed(by: disposeBag)
    }
    
    enum Event {
        case presentEditStudyRecordVC(Int)
        case presentRecordDeleteAlert(Int)
        case notifyLongPress
        case notifyDelete(Bool)
        case reloadTableView
    }
    struct Item {
        let record: Record
        let studyTime: (todayText: String,
                        totalText: String)
    }
    
    private func convertToItems(records: [Record]) -> [Item] {
        return records.enumerated().map { index, record in
            Item(
                record: record,
                studyTime: recordUseCase.getStudyTime(at: index)
            )
        }
    }
    
}

// MARK: - Input
extension StudyRecordViewModel: StudyRecordViewModelInput {
    
    func viewWillAppear() {
        isHiddenTableViewRelay.accept(records.isEmpty)
        itemRelay.accept(convertToItems(records: records))
        recordUseCase.readRecords()
    }
    
    func baseViewTapDidRecognized(row: Int) {
        eventRelay.accept(.presentEditStudyRecordVC(row))
    }
    
    func baseViewLongPressDidRecognized() {
        eventRelay.accept(.notifyLongPress)
    }
    
    func memoButtonDidTapped(row: Int, tableView: UITableView) {
        recordUseCase.changeOpeningAndClosing(at: row)
        recordUseCase.readRecords()
        DispatchQueue.main.async {
            self.eventRelay.accept(.reloadTableView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let cell = tableView.cellForRow(
                at: IndexPath(row: row, section: 0)
            ) as? RecordTableViewCell
            let isExpanded = self.records[row].isExpanded
            let isLastRow = (row == self.records.count - 1)
            let isManyMemo = (cell?.frame.height ?? 0.0 > tableView.frame.height / 2)
            let isCellNil = (cell == nil)
            let shouldScrollToTop = isExpanded && (isManyMemo || isLastRow || isCellNil)
            if shouldScrollToTop {
                tableView.scrollToRow(at: IndexPath(row: row, section: 0),
                                      at: .top,
                                      animated: true)
            }
        }
    }
    
    func deleteButtonDidTappped(row: Int) {
        eventRelay.accept(.presentRecordDeleteAlert(row))
    }
    
    func recordDeleteAlertDeleteButtonDidTapped(row: Int) {
        recordUseCase.deleteRecord(record: records[row])
        recordUseCase.readRecords()
        eventRelay.accept(.reloadTableView)
        eventRelay.accept(.notifyDelete(records.isEmpty))
        isHiddenTableViewRelay.accept(records.isEmpty)
    }
    
}

// MARK: - Output
extension StudyRecordViewModel: StudyRecordViewModelOutput {
    
    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var items: Observable<[Item]> {
        itemRelay.asObservable()
    }
    
    var isHiddenTableView: Driver<Bool> {
        isHiddenTableViewRelay.asDriver(onErrorDriveWith: .empty())
    }
    
}

extension StudyRecordViewModel: StudyRecordViewModelType {
    
    var inputs: StudyRecordViewModelInput {
        return self
    }
    
    var outputs: StudyRecordViewModelOutput {
        return self
    }
    
}
