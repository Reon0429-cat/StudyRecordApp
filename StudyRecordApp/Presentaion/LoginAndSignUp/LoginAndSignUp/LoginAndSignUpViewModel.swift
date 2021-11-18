//
//  LoginAndSignUpViewModel.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginAndSignUpViewModelInput {
    func swipeToLeft()
    func swipeToRight()
}

protocol LoginAndSignUpViewModelOutput: AnyObject {
    var authViewType: Driver<LoginAndSignUpViewModel.AuthViewType> { get }
}

protocol LoginAndSignUpViewModelType {
    var inputs: LoginAndSignUpViewModelInput { get }
    var outputs: LoginAndSignUpViewModelOutput { get }
}

final class LoginAndSignUpViewModel {

    enum AuthViewType {
        case login
        case signUp
    }

    private let disposeBag = DisposeBag()
    private let authViewTypeRelay = BehaviorRelay<AuthViewType>(value: .login)

    init(loginButton: Signal<Void>,
         signUpButton: Signal<Void>) {

        loginButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.authViewTypeRelay.accept(.login)
            })
            .disposed(by: disposeBag)

        signUpButton
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.authViewTypeRelay.accept(.signUp)
            })
            .disposed(by: disposeBag)

    }

}

// MARK: - Input
extension LoginAndSignUpViewModel: LoginAndSignUpViewModelInput {

    func swipeToLeft() {
        authViewTypeRelay.accept(.signUp)
    }

    func swipeToRight() {
        authViewTypeRelay.accept(.login)
    }

}

// MARK: - Output
extension LoginAndSignUpViewModel: LoginAndSignUpViewModelOutput {

    var authViewType: Driver<AuthViewType> {
        authViewTypeRelay.asDriver()
    }

}

extension LoginAndSignUpViewModel: LoginAndSignUpViewModelType {

    var inputs: LoginAndSignUpViewModelInput {
        return self
    }

    var outputs: LoginAndSignUpViewModelOutput {
        return self
    }

}
