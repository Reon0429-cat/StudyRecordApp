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
    var reload: Driver<StudyRecordViewModel.ReloadType> { get }
    var records: [Record] { get }
    func getStudyTime(at row: Int) -> (todayText: String,
                                       totalText: String)
}

protocol StudyRecordViewModelType {
    var inputs: StudyRecordViewModelInput { get }
    var outputs: StudyRecordViewModelOutput { get }
}

final class StudyRecordViewModel {
   
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private let disposeBag = DisposeBag()
    enum Event {
        case notifyDisplayed
        case presentEditStudyRecordVC(selectedRow: Int)
        case notifyLongPress
        case scrollToRow(selectedRow: Int)
        case presentAlert(selectedRow: Int)
    }
    enum ReloadType {
        case all
        case rows(row: Int)
    }
    
    private var eventRelay = PublishRelay<Event>()
    private var reloadRelay = PublishRelay<ReloadType>()
    
}

// MARK: - Input
extension StudyRecordViewModel: StudyRecordViewModelInput {
    
    func viewWillAppear() {
        eventRelay.accept(.notifyDisplayed)
        reloadRelay.accept(.all)
    }
    
    func baseViewTapDidRecognized(row: Int) {
        eventRelay.accept(.presentEditStudyRecordVC(selectedRow: row))
    }
    
    func baseViewLongPressDidRecognized() {
        eventRelay.accept(.notifyLongPress)
    }
    
    func memoButtonDidTapped(row: Int) {
        recordUseCase.changeOpeningAndClosing(at: row)
        reloadRelay.accept(.rows(row: row))
        eventRelay.accept(.scrollToRow(selectedRow: row))
    }
    
    func deleteButtonDidTappped(row: Int) {
        eventRelay.accept(.presentAlert(selectedRow: row))
    }
    
    func deleteRecord(row: Int) {
        recordUseCase.delete(at: row)
    }
    
    func scrollToRow(tableView: UITableView, row: Int) {
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

// MARK: - Output
extension StudyRecordViewModel: StudyRecordViewModelOutput {
    
    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var reload: Driver<ReloadType> {
        reloadRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var records: [Record] {
        recordUseCase.records
    }
    
    func getStudyTime(at row: Int) -> (todayText: String,
                                       totalText: String) {
        return recordUseCase.getStudyTime(at: row)
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
