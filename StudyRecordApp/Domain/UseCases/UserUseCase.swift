//
//  UserUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/28.
//

import UIKit

final class UserUseCase {
    
    private var repository: UserRepositoryProtocol
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    var isLoggedIn: Bool {
        repository.currentUser != nil
    }
    
    var isLoggedInAsAnonymously: Bool {
        if let user = repository.currentUser {
            return user.isAnonymous
        }
        return false
    }
    
    func registerUser(email: String,
                      password: String,
                      completion: @escaping ResultHandler<User>) {
        repository.registerUser(email: email,
                                password: password,
                                completion: completion)
    }
    
    func createUser(userId: String,
                    email: String,
                    completion: @escaping ResultHandler<Any?>) {
        repository.createUser(userId: userId,
                              email: email,
                              completion: completion)
    }
    
    func login(email: String,
               password: String,
               completion: @escaping ResultHandler<Any?>) {
        repository.login(email: email,
                         password: password,
                         completion: completion)
    }
    
    func logout(completion: @escaping ResultHandler<Any?>) {
        repository.logout(completion: completion)
    }
    
    func sendPasswordResetMail(email: String,
                               completion: @escaping ResultHandler<Any?>) {
        repository.sendPasswordResetMail(email: email,
                                         completion: completion)
    }
    
    func signInAnonymously(completion: @escaping ResultHandler<Any?>) {
        repository.signInAnonymously(completion: completion)
    }
    
}
