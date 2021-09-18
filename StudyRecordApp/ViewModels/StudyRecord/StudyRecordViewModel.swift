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
}

protocol StudyRecordViewModelOutput: AnyObject {
    var event: Driver<StudyRecordViewModel.Event> { get }
    var records: [Record] { get }
    func getStudyTime(at row: Int) -> (todayText: String,
                                       totalText: String)
}

protocol StudyRecordViewModelType {
    var inputs: StudyRecordViewModelInput { get }
    var outputs: StudyRecordViewModelOutput { get }
}

final class StudyRecordViewModel: StudyRecordViewModelInput,
                                  StudyRecordViewModelOutput {
   
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private let disposeBag = DisposeBag()
    enum Event {
        case notifyDisplayed
        case reloadData
        case presentEditStudyRecordVC(selectedRow: Int)
        case notifyLongPress
        case reloadRows(selectedRow: Int)
        case scrollToRow(selectedRow: Int)
        case presentAlert(selectedRow: Int)
    }
    
    func viewWillAppear() {
        eventRelay.accept(.notifyDisplayed)
        eventRelay.accept(.reloadData)
    }
    
    func baseViewTapDidRecognized(row: Int) {
        eventRelay.accept(.presentEditStudyRecordVC(selectedRow: row))
    }
    
    func baseViewLongPressDidRecognized() {
        eventRelay.accept(.notifyLongPress)
    }
    
    func memoButtonDidTapped(row: Int) {
        recordUseCase.changeOpeningAndClosing(at: row)
        eventRelay.accept(.reloadRows(selectedRow: row))
        eventRelay.accept(.scrollToRow(selectedRow: row))
    }
    
    func deleteButtonDidTappped(row: Int) {
        eventRelay.accept(.presentAlert(selectedRow: row))
    }
    
    func deleteRecord(row: Int) {
        recordUseCase.delete(at: row)
    }
    
    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    private var eventRelay = PublishRelay<Event>()
    
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
