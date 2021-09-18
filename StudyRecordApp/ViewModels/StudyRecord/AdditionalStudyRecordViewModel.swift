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
    func titleCellDidTapped<T: UITextFieldDelegate>(vc: T)
    func graphColorCellDidTapped<T: StudyRecordGraphColorVCDelegate>(vc: T)
    func memoCellDidTapped<T: StudyRecordMemoVCDelegate>(vc: T)
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

final class AdditionalStudyRecordViewModel: AdditionalStudyRecordViewModelInput,
                                            AdditionalStudyRecordViewModelOutput {
    
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
        case presentAlert(UIAlertController)
        case reloadData
        case presentVC(UIViewController)
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
    
    func createAlert() -> UIAlertController {
        let alert = Alert.create(title: LocalizeKey.doYouWantToCloseWithoutSaving.localizedString())
            .addAction(title: LocalizeKey.close.localizedString(),
                       style: .destructive) {
                self.eventRelay.accept(.dismiss)
            }
            .addAction(title: LocalizeKey.save.localizedString()) {
                self.saveRecord()
                self.eventRelay.accept(.dismiss)
            }
        return alert
    }
    
    func createAlertWithTextField<T: UITextFieldDelegate>(vc: T) -> UIAlertController {
        let alert = Alert.create(title: LocalizeKey.Title.localizedString())
            .setTextField { textField in
                textField.tintColor = .dynamicColor(light: .black, dark: .white)
                textField.text = self.inputtedTitle
                textField.delegate = vc
            }
            .addAction(title: LocalizeKey.close.localizedString(),
                       style: .destructive) {
                self.inputtedTitle = self.oldInputtedTitle
            }
            .addAction(title: LocalizeKey.add.localizedString()) {
                self.oldInputtedTitle = self.inputtedTitle
                self.eventRelay.accept(.reloadData)
            }
        return alert
    }
    
}

// MARK: - Input
extension AdditionalStudyRecordViewModel {
    
    func titleCellDidTapped<T: UITextFieldDelegate>(vc: T) {
        eventRelay.accept(.presentAlert(createAlertWithTextField(vc: vc)))
    }
    
    func graphColorCellDidTapped<T: StudyRecordGraphColorVCDelegate>(vc: T) {
        let studyRecordGraphColorVC = StudyRecordGraphColorViewController.instantiate()
        studyRecordGraphColorVC.modalPresentationStyle = .overCurrentContext
        studyRecordGraphColorVC.modalTransitionStyle = .crossDissolve
        studyRecordGraphColorVC.delegate = vc
        eventRelay.accept(.presentVC(studyRecordGraphColorVC))
    }

    func memoCellDidTapped<T: StudyRecordMemoVCDelegate>(vc: T) {
        let studyRecordMemoVC = StudyRecordMemoViewController.instantiate()
        studyRecordMemoVC.modalPresentationStyle = .overCurrentContext
        studyRecordMemoVC.modalTransitionStyle = .crossDissolve
        studyRecordMemoVC.delegate = vc
        studyRecordMemoVC.inputtedMemo = inputtedMemo
        eventRelay.accept(.presentVC(studyRecordMemoVC))
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
            eventRelay.accept(.presentAlert(createAlert()))
        } else {
            eventRelay.accept(.dismiss)
        }
    }
    
}

// MARK: - Output
extension AdditionalStudyRecordViewModel {
    
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
