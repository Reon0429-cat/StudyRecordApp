//
//  RxUserRepositoryProtocol.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation
import RxSwift

protocol RxUserRepositoryProtocol {
    func fetchCurrentUser() -> Single<User?>
    func registerUser(email: String, password: String) -> Single<User>
    func createUser(userId: String, email: String) -> Completable
    func login(email: String, password: String) -> Completable
    func logout() -> Completable
    func sendPasswordResetMail(email: String) -> Completable
    func signInAnonymously() -> Completable
}
