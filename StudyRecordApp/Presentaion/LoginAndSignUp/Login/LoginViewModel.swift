//
//  LoginViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelInput {
    func viewDidLoad()
    func keyboardWillShow()
    func keyboardWillHide()
}

protocol LoginViewModelOutput: AnyObject {
    var shouldPasswordTextFieldSecure: Driver<Bool> { get }
    var stackViewTopConstant: Signal<CGFloat> { get }
    var isLoginButtonEnabled: Driver<Bool> { get }
    var passwordSecureButtonImage: Driver<UIImage> { get }
    var event: Signal<LoginViewModel.Event> { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInput { get }
    var outputs: LoginViewModelOutput { get }
}

final class LoginViewModel {
    
    private var isPasswordHidden = true
    private var isKeyboardHidden = true
    private let indicator = Indicator(kinds: PKHUDIndicator())
    private let isEyeFillImageRelay = PublishRelay<Bool>()
    private let passwordForgotButtonRelay = PublishRelay<Void>()
    private let shouldPasswordTextFieldSecureRelay = BehaviorRelay<Bool>(value: true)
    private let stackViewTopConstantRelay = PublishRelay<CGFloat>()
    private let eventRelay = PublishRelay<Event>()
    private let isLoginButtonEnabledRelay = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    enum Event {
        case dismiss
        case presentResetingPassword
        case showErrorAlert(title: String)
    }
    
    init(userUseCase: UserUseCase,
         mailText: Driver<String>,
         passwordText: Driver<String>,
         loginButton: Signal<Void>,
         passwordSecureButton: Signal<Void>,
         passwordForgotButton: Signal<Void>) {
        
        Observable
            .combineLatest(
                mailText.asObservable(),
                passwordText.asObservable()
            )
            .map { !$0.isEmpty && !$1.isEmpty }
            .bind(to: isLoginButtonEnabledRelay)
            .disposed(by: disposeBag)
        
        loginButton
            .withLatestFrom(
                Signal.combineLatest(
                    mailText.asSignal(onErrorJustReturn: ""),
                    passwordText.asSignal(onErrorJustReturn: "")
                )
            )
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.indicator.show(.progress)
                userUseCase.login(email: $0, password: $1)
                    .subscribe(
                        onCompleted: {
                            self.indicator.flash(.success) {
                                self.eventRelay.accept(.dismiss)
                            }
                        }, onError: { error in
                            self.indicator.flash(.error) {
                                self.eventRelay.accept(.showErrorAlert(title: error.toAuthErrorMessage))
                            }
                        }
                    )
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        passwordSecureButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.isEyeFillImageRelay.accept(self.isPasswordHidden)
                self.shouldPasswordTextFieldSecureRelay.accept(!self.shouldPasswordTextFieldSecureRelay.value)
                self.isPasswordHidden.toggle()
            })
            .disposed(by: disposeBag)
        
        passwordForgotButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.eventRelay.accept(.presentResetingPassword)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Input
extension LoginViewModel: LoginViewModelInput {
    
    func viewDidLoad() {
        isEyeFillImageRelay.accept(false)
        shouldPasswordTextFieldSecureRelay.accept(true)
    }
    
    func keyboardWillShow() {
        if isKeyboardHidden {
            stackViewTopConstantRelay.accept(-100)
        }
        isKeyboardHidden = false
    }
    
    func keyboardWillHide() {
        if !isKeyboardHidden {
            stackViewTopConstantRelay.accept(100)
        }
        isKeyboardHidden = true
    }
    
}

// MARK: - Output
extension LoginViewModel: LoginViewModelOutput {
    
    var shouldPasswordTextFieldSecure: Driver<Bool> {
        shouldPasswordTextFieldSecureRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var stackViewTopConstant: Signal<CGFloat> {
        stackViewTopConstantRelay.asSignal()
    }
    
    var passwordSecureButtonImage: Driver<UIImage> {
        isEyeFillImageRelay
            .map { isSlash in
                if isSlash {
                    return UIImage(systemName: .eyeSlashFill)
                }
                return UIImage(systemName: .eyeFill)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var event: Signal<Event> {
        eventRelay.asSignal()
    }
    
    var isLoginButtonEnabled: Driver<Bool> {
        isLoginButtonEnabledRelay.asDriver()
    }
    
}

extension LoginViewModel: LoginViewModelType {
    
    var inputs: LoginViewModelInput {
        return self
    }
    
    var outputs: LoginViewModelOutput {
        return self
    }
    
}
