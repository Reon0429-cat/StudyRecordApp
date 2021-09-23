//
//  AdditionalStudyRecordViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/19.
//

import RxSwift
import RxCocoa

protocol AdditionalStudyRecordViewModelInput {
    func viewDidLoad()
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
    var items: Driver<[AdditionalStudyRecordViewModel.CellItem]> { get }
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
        case presentAlertWithTextField(text: String)
        case presentStudyRecordGraphColorVC
        case presentStudyRecordMemoVC(memo: String)
    }
    enum CellItem {
        case title(String)
        case graphColor(UIColor)
        case memo(String)
    }
    
    private let eventRelay = PublishRelay<Event>()
    private let itemsRelay = BehaviorRelay<[CellItem]>(value: [])
    private let controlSaveButtonRelay = BehaviorRelay<Bool>(value: false)
    
    private func saveRecord() {
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
    
    func viewDidLoad() {
        itemsRelay.accept([.title(inputtedTitle),
                           .graphColor(selectedGraphColor),
                           .memo(inputtedMemo)])
    }
    
    func titleCellDidTapped() {
        eventRelay.accept(.presentAlertWithTextField(text: inputtedTitle))
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
    
    var items: Driver<[CellItem]> {
        itemsRelay.asDriver(onErrorDriveWith: .empty())
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
