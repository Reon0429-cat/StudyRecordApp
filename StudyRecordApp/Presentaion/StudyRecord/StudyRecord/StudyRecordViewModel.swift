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
    func memoButtonDidTapped(row: Int)
    func deleteButtonDidTappped(row: Int)
    func recordDeleteAlertDeleteButtonDidTapped(row: Int)
    func reloadLocalData()
    func recordAdded()
}

protocol StudyRecordViewModelOutput: AnyObject {
    var event: Signal<StudyRecordViewModel.Event> { get }
    var items: Driver<[StudyRecordViewModel.Item]> { get }
    var isHiddenTableView: Driver<Bool> { get }
}

protocol StudyRecordViewModelType {
    var inputs: StudyRecordViewModelInput { get }
    var outputs: StudyRecordViewModelOutput { get }
}

final class StudyRecordViewModel {

    private let eventRelay = PublishRelay<Event>()
    private let isHiddenTableViewRelay = PublishRelay<Bool>()
    private let itemRelay = BehaviorRelay<[Item]>(value: [])
    private var records: [Record] {
        itemRelay.value.map { $0.record }
    }

    private let recordUseCase: RxRecordUseCase
    private let disposeBag = DisposeBag()

    init(recordUseCase: RxRecordUseCase,
         registerButton: Signal<Void>) {

        self.recordUseCase = recordUseCase

        registerButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.eventRelay.accept(.presentAdditionalStudyRecordVC)
            })
            .disposed(by: disposeBag)

        readItems()
    }

    enum Event {
        case presentEditStudyRecordVC(Int)
        case presentAdditionalStudyRecordVC
        case presentRecordDeleteAlert(Int)
        case notifyLongPress
        case notifyDelete(Bool)
        case scrollToTop(row: Int, records: [Record])
    }

    struct Item {
        let record: Record
        let studyTime: (todayText: String, totalText: String)
    }

    private func convertToItems(records: [Record]) -> [Item] {
        return records.map { record in
            Item(
                record: record,
                studyTime: recordUseCase.getStudyTime(record: record)
            )
        }
    }

    private func readItems() {
        recordUseCase.readRecords()
            .compactMap { [weak self] in self?.convertToItems(records: $0) }
            .subscribe(
                onSuccess: { [weak self] in self?.itemRelay.accept($0) },
                onError: { print("DEBUG_PRINT: ", $0.localizedDescription) }
            )
            .disposed(by: disposeBag)
    }

}

// MARK: - Input
extension StudyRecordViewModel: StudyRecordViewModelInput {

    func viewWillAppear() {
        isHiddenTableViewRelay.accept(records.isEmpty)
    }

    func baseViewTapDidRecognized(row: Int) {
        eventRelay.accept(.presentEditStudyRecordVC(row))
    }

    func baseViewLongPressDidRecognized() {
        eventRelay.accept(.notifyLongPress)
    }

    func memoButtonDidTapped(row: Int) {
        recordUseCase.changeOpeningAndClosing(record: records[row])
            .subscribe()
            .disposed(by: disposeBag)
        readItems()
        eventRelay.accept(.scrollToTop(row: row, records: records))
    }

    func deleteButtonDidTappped(row: Int) {
        eventRelay.accept(.presentRecordDeleteAlert(row))
    }

    func recordDeleteAlertDeleteButtonDidTapped(row: Int) {
        recordUseCase.deleteRecord(record: records[row])
            .subscribe()
            .disposed(by: disposeBag)
        readItems()
        eventRelay.accept(.notifyDelete(records.isEmpty))
        isHiddenTableViewRelay.accept(records.isEmpty)
    }

    func reloadLocalData() {
        readItems()
    }

    func recordAdded() {
        readItems()
    }

}

// MARK: - Output
extension StudyRecordViewModel: StudyRecordViewModelOutput {

    var event: Signal<Event> {
        eventRelay.asSignal()
    }

    var items: Driver<[Item]> {
        itemRelay.asDriver()
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
