//
//  LoginViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelInput {
    func viewDidLoad()
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
    
    enum Event {
        case keyboardWillShow
        case keyboardWillHide
    }
    
    private var isPasswordHidden = true
    private var isKeyboardHidden = true
    
    private let passwordSecureButtonImageNameRelay = BehaviorRelay<String>(value: "eye.fill")
    private let passwordIsSecuredRelay = BehaviorRelay<Bool>(value: true)
    private let eventRelay = PublishRelay<Event>()
    private let mailAddressTextRelay = BehaviorRelay<String>(value: "")
    private let passwordTextRelay = BehaviorRelay<String>(value: "")

    private func changePasswordSecureButtonImage(isSlash: Bool) {
        let imageName = isSlash ? "eye.slash.fill" : "eye.fill"
        passwordSecureButtonImageNameRelay.accept(imageName)
    }
    
}

// MARK: - Input
extension LoginViewModel: LoginViewModelInput {
    
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
