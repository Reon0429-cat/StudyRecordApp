//
//  RxUserUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import RxSwift
import RxRelay

final class RxUserUseCase {
    
    private var repository: RxUserRepositoryProtocol
    init(repository: RxUserRepositoryProtocol) {
        self.repository = repository
        setupBindings()
    }
    private let disposeBag = DisposeBag()
    private let isLoggedInRelay = PublishRelay<Bool>()
    private let isLoggedInTrigger = PublishRelay<Void>()
    private let loginTrigger = PublishRelay<(email: String, password: String)>()
    private let loginSuccessRelay = PublishRelay<Void>()
    private let loginErrorRelay = PublishRelay<Error>()
    
    var isLoggedIn: Single<Bool> {
        isLoggedInRelay.asSingle()
    }
    
    var loginSuccess: Observable<Void> {
        loginSuccessRelay.asObservable()
    }
    
    var loginError: Observable<Error> {
        loginErrorRelay.asObservable()
    }
    
    private func setupBindings() {
        isLoggedInTrigger
            .flatMapLatest { self.repository.currentUser }
            .map { $0 != nil }
            .bind(to: isLoggedInRelay)
            .disposed(by: disposeBag)
        
        loginTrigger
            .subscribe(onNext: { email, password in
                self.repository.login(email: email,
                                      password: password)
                    .subscribe {
                        self.loginSuccessRelay.accept(())
                    } onError: { error in
                        self.loginErrorRelay.accept(error)
                    }
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    func login(email: String,
               password: String) {
        loginTrigger.accept((email: email,
                             password: password))
    }
    
}
