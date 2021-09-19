//
//  AdditionalStudyRecordViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/19.
//

import RxSwift
import RxCocoa

protocol AdditionalStudyRecordViewModelInput {
    func graphColorDidSelected(color: UIColor)
    func savedMemo(memo: String)
    func textFieldDidChangeSelection(_ textField: UITextField)
    func saveButtonDidTapped()
    func dismissButtonDidTapped()
    func titleCellDidTapped()
    func graphColorCellDidTapped()
    func memoCellDidTapped()
    func alertWithTextFieldAddButtonDidTapped()
    func alertWithTextFieldCloseButtonDidTapped()
}

protocol AdditionalStudyRecordViewModelOutput: AnyObject {
    var event: Driver<AdditionalStudyRecordViewModel.Event> { get }
    var records: [Record] { get }
    var titleText: String { get }
    var graphColor: UIColor { get }
    var memoText: String { get }
    var controlSaveButton: Driver<Bool> { get }
}

protocol AdditionalStudyRecordViewModelType {
    var inputs: AdditionalStudyRecordViewModelInput { get }
    var outputs: AdditionalStudyRecordViewModelOutput { get }
}

final class AdditionalStudyRecordViewModel {
    
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private var inputtedTitle = ""
    private var oldInputtedTitle = ""
    private var selectedGraphColor: UIColor = .clear
    private var inputtedMemo = ""
    private var isMandatoryItemFilled: Bool {
        !inputtedTitle.isEmpty && selectedGraphColor != .clear
    }
    enum Event {
        case dismiss
        case reloadData
        case presentAlert
        case presentAlertWithTextField
        case presentStudyRecordGraphColorVC
        case presentStudyRecordMemoVC(memo: String)
    }
    
    private let eventRelay = PublishRelay<Event>()
    private let controlSaveButtonRelay = BehaviorRelay<Bool>(value: false)
    
    func saveRecord() {
        let record = Record(title: inputtedTitle,
                            histories: nil,
                            isExpanded: false,
                            graphColor: GraphColor(color: selectedGraphColor),
                            memo: inputtedMemo,
                            yearID: UUID().uuidString,
                            monthID: UUID().uuidString,
                            order: recordUseCase.records.count)
        recordUseCase.save(record: record)
    }
    
}

// MARK: - Input
extension AdditionalStudyRecordViewModel: AdditionalStudyRecordViewModelInput {
    
    func titleCellDidTapped() {
        eventRelay.accept(.presentAlertWithTextField)
    }
    
    func graphColorCellDidTapped() {
        eventRelay.accept(.presentStudyRecordGraphColorVC)
    }

    func memoCellDidTapped() {
        eventRelay.accept(.presentStudyRecordMemoVC(memo: inputtedMemo))
    }
    
    func graphColorDidSelected(color: UIColor) {
        selectedGraphColor = color
        eventRelay.accept(.reloadData)
        controlSaveButtonRelay.accept(isMandatoryItemFilled)
    }
    
    func savedMemo(memo: String) {
        inputtedMemo = memo
        eventRelay.accept(.reloadData)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputtedTitle = textField.text ?? ""
        controlSaveButtonRelay.accept(isMandatoryItemFilled)
    }
    
    func saveButtonDidTapped() {
        saveRecord()
        eventRelay.accept(.dismiss)
    }
    
    func dismissButtonDidTapped() {
        if isMandatoryItemFilled {
            eventRelay.accept(.presentAlert)
        } else {
            eventRelay.accept(.dismiss)
        }
    }
    
    func alertWithTextFieldCloseButtonDidTapped() {
        inputtedTitle = oldInputtedTitle
    }
    
    func alertWithTextFieldAddButtonDidTapped() {
        oldInputtedTitle = inputtedTitle
    }

}

// MARK: - Output
extension AdditionalStudyRecordViewModel: AdditionalStudyRecordViewModelOutput {
    
    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var records: [Record] {
        recordUseCase.records
    }
    
    var titleText: String {
        return inputtedTitle
    }
    
    var graphColor: UIColor {
        return selectedGraphColor
    }
    
    var memoText: String {
        return inputtedMemo
    }
    
    var controlSaveButton: Driver<Bool> {
        controlSaveButtonRelay.asDriver(onErrorDriveWith: .empty())
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
