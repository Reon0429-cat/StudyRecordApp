//
//  StudyRecordViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/19.
//

import RxSwift
import RxCocoa

protocol StudyRecordViewModelInput {
    func viewWillAppear()
    func baseViewTapDidRecognized(row: Int)
    func baseViewLongPressDidRecognized()
    func memoButtonDidTapped(row: Int)
    func deleteButtonDidTappped(row: Int)
    func deleteRecord(row: Int)
    func scrollToRow(tableView: UITableView, row: Int)
}

protocol StudyRecordViewModelOutput: AnyObject {
    var event: Driver<StudyRecordViewModel.Event> { get }
    var records: Driver<[(record: Record, studyTime: StudyRecordViewModel.StudyTime)]> { get }
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
    private let disposeBag = DisposeBag()
    private var eventRelay = PublishRelay<Event>()
    private var recordsRelay = BehaviorRelay<[Record]?>(value: nil)
    
    init() {
        setupBindings()
        recordUseCase.readAll()
    }
    
    struct StudyTime {
        let todayText: String
        let totalText: String
    }
    enum Event {
        case notifyDisplayed(records: [Record])
        case presentEditStudyRecordVC(selectedRow: Int)
        case notifyLongPress
        case scrollToRow(selectedRow: Int)
        case presentAlert(selectedRow: Int, records: [Record])
    }
    
    private func setupBindings() {
        recordUseCase.records
            .compactMap { $0 }
            .bind(to: recordsRelay)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Input
extension StudyRecordViewModel: StudyRecordViewModelInput {
    
    func viewWillAppear() {
        recordUseCase.readAll()
        guard let records = recordsRelay.value else { return }
        eventRelay.accept(.notifyDisplayed(records: records))
    }
    
    func baseViewTapDidRecognized(row: Int) {
        eventRelay.accept(.presentEditStudyRecordVC(selectedRow: row))
    }
    
    func baseViewLongPressDidRecognized() {
        eventRelay.accept(.notifyLongPress)
    }
    
    func memoButtonDidTapped(row: Int) {
        recordUseCase.changeOpeningAndClosing(at: row)
        recordUseCase.readAll()
        eventRelay.accept(.scrollToRow(selectedRow: row))
    }
    
    func deleteButtonDidTappped(row: Int) {
        guard let records = recordsRelay.value else { return }
        eventRelay.accept(.presentAlert(selectedRow: row, records: records))
    }
    
    func deleteRecord(row: Int) {
        recordUseCase.delete(at: row)
        recordUseCase.readAll()
    }
    
    func scrollToRow(tableView: UITableView, row: Int) {
        let cell = tableView.cellForRow(
            at: IndexPath(row: row, section: 0)
        ) as? RecordTableViewCell
        guard let records = recordsRelay.value else { return }
        let isExpanded = records[row].isExpanded
        let isLastRow = (row == records.count - 1)
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

// MARK: - Output
extension StudyRecordViewModel: StudyRecordViewModelOutput {
    
    var records: Driver<[(record: Record, studyTime: StudyTime)]> {
        recordsRelay.asDriver(onErrorDriveWith: .empty())
            .compactMap { $0 }
            .map {
                return $0.enumerated()
                    .map { index, record -> (record: Record, studyTime: StudyTime) in
                        let studyTime = self.recordUseCase.getStudyTime(at: index)
                        let studyTimeText = StudyTime(todayText: studyTime.todayText,
                                                      totalText: studyTime.totalText)
                        return (record: record, studyTime: studyTimeText)
                    }
            }
    }
    
   
    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
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
