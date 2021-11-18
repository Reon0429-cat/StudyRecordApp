//
//  RxUserRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation
import RxSwift
import FirebaseAuth

final class RxUserRepository: RxUserRepositoryProtocol {

    private var dataStore = FirebaseUserDataStore()

    func fetchCurrentUser() -> Single<User?> {
        if let user = dataStore.currentUser {
            return .just(User(user: user))
        }
        return .just(nil)
    }

    func registerUser(email: String, password: String) -> Single<User> {
        Single<User>.create { observer in
            self.dataStore.registerUser(email: email, password: password) { result in
                switch result {
                case .failure(let error):
                    observer(.failure(error))
                case .success(let user):
                    observer(.success(User(user: user)))
                }
            }
            return Disposables.create()
        }
    }

    func createUser(userId: String, email: String) -> Completable {
        Completable.create { observer in
            self.dataStore.createUser(userId: userId, email: email) { result in
                switch result {
                case .failure(let error):
                    observer(.error(error))
                case .success:
                    observer(.completed)
                }
            }
            return Disposables.create()
        }
    }

    func signInAnonymously() -> Completable {
        Completable.create { observer in
            self.dataStore.signInAnonymously { result in
                switch result {
                case .failure(let error):
                    observer(.error(error))
                case .success:
                    observer(.completed)
                }
            }
            return Disposables.create()
        }
    }

    func login(email: String, password: String) -> Completable {
        Completable.create { observer in
            self.dataStore.login(email: email,
                                 password: password) { result in
                switch result {
                case .failure(let error):
                    observer(.error(error))
                case .success:
                    observer(.completed)
                }
            }
            return Disposables.create()
        }
    }

    func logout() -> Completable {
        Completable.create { observer in
            self.dataStore.logout { result in
                switch result {
                case .failure(let error):
                    observer(.error(error))
                case .success:
                    observer(.completed)
                }
            }
            return Disposables.create()
        }
    }

    func sendPasswordResetMail(email: String) -> Completable {
        Completable.create { observer in
            self.dataStore.sendPasswordResetMail(email: email) { result in
                switch result {
                case .failure(let error):
                    observer(.error(error))
                case .success:
                    observer(.completed)
                }
            }
            return Disposables.create()
        }
    }

}

private extension User {

    init(user: FirebaseAuth.User) {
        self.id = user.uid
        self.isAnonymous = user.isAnonymous
    }

}
