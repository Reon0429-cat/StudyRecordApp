//
//  LoginViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

protocol LoginViewModelInput {
    func viewDidLoad()
    func loginButtonDidTapped()
    func passwordForgotButtonDidTapped()
    func passwordSecureButtonDidTapped()
    func mailAddressTextFieldDidEntered(text: String)
    func passwordTextFieldDidEntered(text: String)
    func notifiedKeyboardShowed()
    func notifiedKeyboardHidden()
}

protocol LoginViewModelOutput: AnyObject {
    var passwordSecureButtonImageName: Driver<String> { get }
    var passwordIsSecured: Driver<Bool> { get }
    var loginButtonIsEnabled: Driver<Bool> { get }
    var event: Driver<LoginViewModel.Event> { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInput { get }
    var outputs: LoginViewModelOutput { get }
}

final class LoginViewModel {
    
    init() {
        setupBindings()
    }
    
    private var isPasswordHidden = true
    private var isKeyboardHidden = true
    private var userUseCase = RxUserUseCase(
        repository: RxUserRepository(
            dataStore: RxFirebaseUserDataStore()
        )
    )
    private let disposeBag = DisposeBag()
    private let indicator = Indicator(kinds: PKHUDIndicator())
    enum Event {
        case keyboardWillShow
        case keyboardWillHide
        case presentErrorAlert(String)
        case changeRootVCToTopVC
        case presentResetingPasswordVC
    }
    private let passwordSecureButtonImageNameRelay = BehaviorRelay<String>(value: "eye.fill")
    private let passwordIsSecuredRelay = BehaviorRelay<Bool>(value: true)
    private let eventRelay = PublishRelay<Event>()
    private let mailAddressTextRelay = BehaviorRelay<String>(value: "")
    private let passwordTextRelay = BehaviorRelay<String>(value: "")
    
    private func setupBindings() {
        userUseCase.loginSuccess
            .subscribe(onNext: {
                self.indicator.flash(.success) {
                    self.eventRelay.accept(.changeRootVCToTopVC)
                }
            })
            .disposed(by: disposeBag)
        
        userUseCase.loginError
            .map { self.convertToAuthErrorMessage($0) }
            .subscribe(onNext: { title in
                self.indicator.flash(.error) {
                    self.eventRelay.accept(.presentErrorAlert(title))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func changePasswordSecureButtonImage(isSlash: Bool) {
        let imageName = isSlash ? "eye.slash.fill" : "eye.fill"
        passwordSecureButtonImageNameRelay.accept(imageName)
    }
    
}

// MARK: - Input
extension LoginViewModel: LoginViewModelInput {
    
    func loginButtonDidTapped() {
        if CommunicationStatus().unstable() {
            let title = LocalizeKey.communicationEnvironmentIsNotGood.localizedString()
            eventRelay.accept(.presentErrorAlert(title))
            return
        }
        indicator.show(.progress)
        userUseCase.login(email: mailAddressTextRelay.value,
                          password: passwordTextRelay.value)
    }
    
    func viewDidLoad() {
        changePasswordSecureButtonImage(isSlash: false)
        passwordIsSecuredRelay.accept(true)
    }
    
    func mailAddressTextFieldDidEntered(text: String) {
        mailAddressTextRelay.accept(text)
    }
    
    func passwordTextFieldDidEntered(text: String) {
        passwordTextRelay.accept(text)
    }
    
    func passwordSecureButtonDidTapped() {
        changePasswordSecureButtonImage(isSlash: isPasswordHidden)
        isPasswordHidden.toggle()
        passwordIsSecuredRelay.accept(!passwordIsSecuredRelay.value)
    }
    
    func passwordForgotButtonDidTapped() {
        eventRelay.accept(.presentResetingPasswordVC)
    }
    
    func notifiedKeyboardShowed() {
        if isKeyboardHidden {
            eventRelay.accept(.keyboardWillShow)
        }
        isKeyboardHidden = false
    }
    
    func notifiedKeyboardHidden() {
        if !isKeyboardHidden {
            eventRelay.accept(.keyboardWillHide)
        }
        isKeyboardHidden = true
    }
    
}

// MARK: - Output
extension LoginViewModel: LoginViewModelOutput {
    
    var passwordSecureButtonImageName: Driver<String> {
        passwordSecureButtonImageNameRelay.asDriver()
    }
    
    var passwordIsSecured: Driver<Bool> {
        passwordIsSecuredRelay.asDriver()
    }
    
    var loginButtonIsEnabled: Driver<Bool> {
        return Observable<Bool>.combineLatest(
            mailAddressTextRelay.startWith(""),
            passwordTextRelay.startWith("")
        ) { !$0.isEmpty && !$1.isEmpty }
        .asDriver(onErrorDriveWith: .empty())
    }
    
    var event: Driver<LoginViewModel.Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
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

private extension LoginViewModel {
    
    func convertToAuthErrorMessage(_ error: Error) -> String {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
                case .invalidEmail:
                    return LocalizeKey.theEmailAddressFormatContainsAnError.localizedString()
                case .weakPassword:
                    return LocalizeKey.pleaseEnterThePasswordWithAtLeast6Characters.localizedString()
                case .wrongPassword:
                    return LocalizeKey.thePasswordIsIncorrect.localizedString()
                case .userNotFound:
                    return LocalizeKey.thisEmailAddressIsNotRegistered.localizedString()
                case .emailAlreadyInUse:
                    return LocalizeKey.thisEmailAddressIsAlreadyRegistered.localizedString()
                default:
                    return LocalizeKey.loginFailed.localizedString() + "\(error.localizedDescription)"
            }
        }
        return LocalizeKey.anUnknownErrorHasOccurred.localizedString()
    }
    
}
