//
//  ResetingPasswordViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol ResetingPasswordViewModelInput {
    func willShowedKeyboard()
    func willHiddenKeyboard()
}

protocol ResetingPasswordViewModelOutput: AnyObject {
    var event: Driver<ResetingPasswordViewModel.Event> { get }
    var isEnabledSendButton: Driver<Bool> { get }
    var topConstantOfStackView: Driver<CGFloat> { get }
}

protocol ResetingPasswordViewModelType {
    var inputs: ResetingPasswordViewModelInput { get }
    var outputs: ResetingPasswordViewModelOutput { get }
}

final class ResetingPasswordViewModel {

    private var isKeyboardHidden = true
    private let indicator = Indicator(kinds: PKHUDIndicator())
    private let disposeBag = DisposeBag()

    private let eventRelay = PublishRelay<Event>()
    private let isEnabledSendButtonRelay = BehaviorRelay<Bool>(value: false)
    private let topConstantOfStackViewRelay = PublishRelay<CGFloat>()

    enum Event {
        case dismiss
        case presentErrorAlert(title: String)
    }

    init(userUseCase: RxUserUseCase,
         mailAddressText: Driver<String>,
         sendButton: Signal<Void>) {

        sendButton
            .withLatestFrom(mailAddressText.asSignal(onErrorJustReturn: ""))
            .emit(onNext: { [weak self] mailText in
                guard let self = self else { return }
                self.indicator.show(.progress)
                userUseCase.sendPasswordResetMail(email: mailText)
                    .subscribe(
                        onCompleted: { [weak self] in
                            guard let self = self else { return }
                            self.indicator.flash(.success) {
                                self.eventRelay.accept(.dismiss)
                            }
                        },
                        onError: { [weak self] error in
                            guard let self = self else { return }
                            self.indicator.flash(.error) {
                                self.eventRelay.accept(.presentErrorAlert(title: error.toAuthErrorMessage))
                            }
                        }
                    )
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        mailAddressText
            .map { !$0.isEmpty }
            .drive(onNext: { [weak self] isEnabled in
                guard let self = self else { return }
                self.isEnabledSendButtonRelay.accept(isEnabled)
            })
            .disposed(by: disposeBag)

    }

}

// MARK: - Input
extension ResetingPasswordViewModel: ResetingPasswordViewModelInput {

    func willShowedKeyboard() {
        if isKeyboardHidden {
            topConstantOfStackViewRelay.accept(-30)
        }
        isKeyboardHidden = false
    }

    func willHiddenKeyboard() {
        if !isKeyboardHidden {
            topConstantOfStackViewRelay.accept(30)
        }
        isKeyboardHidden = true
    }

}

// MARK: - Output
extension ResetingPasswordViewModel: ResetingPasswordViewModelOutput {

    var event: Driver<ResetingPasswordViewModel.Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }

    var isEnabledSendButton: Driver<Bool> {
        isEnabledSendButtonRelay.asDriver()
    }

    var topConstantOfStackView: Driver<CGFloat> {
        topConstantOfStackViewRelay.asDriver(onErrorDriveWith: .empty())
    }

}

extension ResetingPasswordViewModel: ResetingPasswordViewModelType {

    var inputs: ResetingPasswordViewModelInput {
        return self
    }

    var outputs: ResetingPasswordViewModelOutput {
        return self
    }

}
