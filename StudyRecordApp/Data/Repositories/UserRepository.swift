//
//  UserRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/29.
//

import Foundation
import FirebaseAuth

final class UserRepository: UserRepositoryProtocol {

    private let dataStore = FirebaseUserDataStore()

    var currentUser: User? {
        if let user = dataStore.currentUser {
            return User(user: user)
        }
        return nil
    }

    func registerUser(email: String,
                      password: String,
                      completion: @escaping ResultHandler<User>) {
        dataStore.registerUser(email: email,
                               password: password) {
            completion($0.map { User(user: $0) })
        }
    }

    func createUser(userId: String,
                    email: String,
                    completion: @escaping ResultHandler<Any?>) {
        dataStore.createUser(userId: userId,
                             email: email,
                             completion: completion)
    }

    func login(email: String,
               password: String,
               completion: @escaping ResultHandler<Any?>) {
        dataStore.login(email: email,
                        password: password,
                        completion: completion)
    }

    func logout(completion: @escaping ResultHandler<Any?>) {
        dataStore.logout(completion: completion)
    }

    func sendPasswordResetMail(email: String,
                               completion: @escaping ResultHandler<Any?>) {
        dataStore.sendPasswordResetMail(email: email,
                                        completion: completion)
    }

    func signInAnonymously(completion: @escaping ResultHandler<Any?>) {
        dataStore.signInAnonymously(completion: completion)
    }

}

private extension User {

    init(user: FirebaseAuth.User) {
        self.id = user.uid
        self.isAnonymous = user.isAnonymous
    }

}
