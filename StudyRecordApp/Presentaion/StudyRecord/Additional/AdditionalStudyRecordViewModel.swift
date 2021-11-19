//
//  AdditionalStudyRecordViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/19.
//

import Foundation
import RxSwift
import RxCocoa

protocol AdditionalStudyRecordViewModelInput {
    func graphColorDidSelected(color: UIColor)
    func savedMemo(memo: String)
    func saveButtonDidTapped()
    func dismissButtonDidTapped()
    func textFieldDidChangeSelection(text: String?)
    func saveAlertSaveButtonDidTapped()
    func textFieldAlertCloseButtonDidTapped()
    func textFieldAlertAddButtonDidTapped(title: String)
    func itemDidSelected(item: AdditionalStudyRecordViewModel.Item)
    func viewDidLoad()
}

protocol AdditionalStudyRecordViewModelOutput: AnyObject {
    var event: Signal<AdditionalStudyRecordViewModel.Event> { get }
    var items: Driver<[AdditionalStudyRecordViewModel.Item]> { get }
    var isEnabledSaveButton: Driver<Bool> { get }
}

protocol AdditionalStudyRecordViewModelType {
    var inputs: AdditionalStudyRecordViewModelInput { get }
    var outputs: AdditionalStudyRecordViewModelOutput { get }
}

final class AdditionalStudyRecordViewModel {

    enum Item {
        case title(String)
        case graphColor(UIColor)
        case memo(String)
    }

    enum Event {
        case dismiss
        case presentStudyRecordGraphColorVC
        case presentStudyRecordMemoVC(memo: String)
        case presentAlert
        case presentAlertWithTextField(text: String)
    }

    private var inputtedTitle = ""
    private var oldInputtedTitle = ""
    private var selectedGraphColor: UIColor = .clear
    private var inputtedMemo = ""
    private var isMandatoryItemFilled: Bool {
        !inputtedTitle.isEmpty && selectedGraphColor != .clear
    }

    private let disposeBag = DisposeBag()
    private let eventRelay = PublishRelay<Event>()
    private let reloadTableRelay = PublishRelay<Void>()
    private let isEnabledSaveButtonRelay = BehaviorRelay<Bool>(value: false)
    private let recordUseCase: RxRecordUseCase

    init(recordUseCase: RxRecordUseCase) {
        self.recordUseCase = recordUseCase
    }

    private func saveRecord() {
        recordUseCase.readRecords()
            .subscribe(
                onSuccess: { [weak self] records in
                    guard let strongSelf = self else { return }
                    let record = Record(title: strongSelf.inputtedTitle,
                                        histories: nil,
                                        isExpanded: false,
                                        graphColor: GraphColor(color: strongSelf.selectedGraphColor),
                                        memo: strongSelf.inputtedMemo,
                                        yearID: UUID().uuidString,
                                        monthID: UUID().uuidString,
                                        order: records.count,
                                        identifier: UUID().uuidString)
                    strongSelf.recordUseCase.createRecord(record: record)
                        .subscribe()
                        .disposed(by: strongSelf.disposeBag)
                },
                onFailure: { print("DEBUG_PRINT: ", $0.localizedDescription) }
            )
            .disposed(by: disposeBag)
    }

    private func notifyRecordAdded() {
        NotificationCenter.default.post(name: .recordAdded, object: nil)
    }

}

// MARK: - Input
extension AdditionalStudyRecordViewModel: AdditionalStudyRecordViewModelInput {

    func viewDidLoad() {
        reloadTableRelay.accept(())
    }

    func graphColorDidSelected(color: UIColor) {
        selectedGraphColor = color
        reloadTableRelay.accept(())
        isEnabledSaveButtonRelay.accept(isMandatoryItemFilled)
    }

    func savedMemo(memo: String) {
        inputtedMemo = memo
        reloadTableRelay.accept(())
    }

    func saveButtonDidTapped() {
        saveRecord()
        notifyRecordAdded()
        eventRelay.accept(.dismiss)
    }

    func dismissButtonDidTapped() {
        if isMandatoryItemFilled {
            eventRelay.accept(.presentAlert)
        } else {
            eventRelay.accept(.dismiss)
        }
    }

    func saveAlertSaveButtonDidTapped() {
        saveRecord()
    }

    func textFieldAlertCloseButtonDidTapped() {
        inputtedTitle = oldInputtedTitle
        reloadTableRelay.accept(())
    }

    func textFieldDidChangeSelection(text: String?) {
        inputtedTitle = text ?? ""
        isEnabledSaveButtonRelay.accept(isMandatoryItemFilled)
    }

    func textFieldAlertAddButtonDidTapped(title: String) {
        oldInputtedTitle = title
        reloadTableRelay.accept(())
    }

    func itemDidSelected(item: Item) {
        switch item {
        case .title:
            eventRelay.accept(.presentAlertWithTextField(text: inputtedTitle))
        case .graphColor:
            eventRelay.accept(.presentStudyRecordGraphColorVC)
        case .memo:
            eventRelay.accept(.presentStudyRecordMemoVC(memo: inputtedMemo))
        }
    }

}

// MARK: - Output
extension AdditionalStudyRecordViewModel: AdditionalStudyRecordViewModelOutput {

    var event: Signal<Event> {
        eventRelay.asSignal()
    }

    var items: Driver<[Item]> {
        reloadTableRelay
            .map {
                [Item.title(self.inputtedTitle),
                 Item.graphColor(self.selectedGraphColor),
                 Item.memo(self.inputtedMemo)]
            }
            .asDriver(onErrorDriveWith: .empty())
    }

    var isEnabledSaveButton: Driver<Bool> {
        isEnabledSaveButtonRelay.asDriver()
    }

}

extension AdditionalStudyRecordViewModel: AdditionalStudyRecordViewModelType {

    var inputs: AdditionalStudyRecordViewModelInput {
        return self
    }

    var outputs: AdditionalStudyRecordViewModelOutput {
        return self
    }

}
