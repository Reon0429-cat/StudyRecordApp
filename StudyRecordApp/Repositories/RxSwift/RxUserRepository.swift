//
//  RxUserRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import RxSwift

protocol RxUserRepositoryProtocol {
    var currentUser: Single<User?> { get }
    func login(email: String,
               password: String) -> Completable
}

final class RxUserRepository: RxUserRepositoryProtocol {
    
    private var dataStore: RxUserDataStoreProtocol
    init(dataStore: RxUserDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    var currentUser: Single<User?> {
        .just(dataStore.currentUser)
    }
    
    func login(email: String,
               password: String) -> Completable {
        return Completable.create { observer in
            self.dataStore.login(email: email,
                                 password: password) { result in
                switch result {
                    case .success:
                        return observer(.completed)
                    case .failure(let error):
                        return observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
}

