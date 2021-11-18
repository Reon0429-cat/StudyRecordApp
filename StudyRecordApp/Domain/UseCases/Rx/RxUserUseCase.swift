//
//  RxUserUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation
import RxSwift
import RxRelay

final class RxUserUseCase {

    private var repository: RxUserRepositoryProtocol

    init(repository: RxUserRepositoryProtocol) {
        self.repository = repository
    }

    var isLoggedIn: Single<Bool> {
        repository.fetchCurrentUser()
            .map { $0 != nil }
    }

    var isLoggedInAsAnonymously: Single<Bool> {
        repository.fetchCurrentUser()
            .map {
                if let user = $0 {
                    return user.isAnonymous
                }
                return false
            }
    }

    func registerUser(email: String, password: String) -> Single<User> {
        repository.registerUser(email: email, password: password)
    }

    func createUser(userId: String, email: String) -> Completable {
        repository.createUser(userId: userId, email: email)
    }

    func login(email: String, password: String) -> Completable {
        repository.login(email: email, password: password)
    }

    func logout() -> Completable {
        repository.logout()
    }

    func sendPasswordResetMail(email: String) -> Completable {
        repository.sendPasswordResetMail(email: email)
    }

    func signInAnonymously() -> Completable {
        repository.signInAnonymously()
    }

}
