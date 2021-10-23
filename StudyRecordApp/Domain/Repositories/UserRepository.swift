//
//  UserRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/29.
//

import Foundation

protocol UserRepositoryProtocol {
    var currentUser: User? { get }
    func registerUser(email: String,
                      password: String,
                      completion: @escaping ResultHandler<User>)
    func createUser(userId: String,
                    email: String,
                    completion: @escaping ResultHandler<Any?>)
    func login(email: String,
               password: String,
               completion: @escaping ResultHandler<Any?>)
    func logout(completion: @escaping ResultHandler<Any?>)
    func sendPasswordResetMail(email: String,
                               completion: @escaping ResultHandler<Any?>)
    func signInAnonymously(completion: @escaping ResultHandler<Any?>)
}

final class UserRepository: UserRepositoryProtocol {
    
    private var dataStore: UserDataStoreProtocol
    init(dataStore: UserDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    var currentUser: User? {
        dataStore.currentUser
    }
    
    func registerUser(email: String,
                      password: String,
                      completion: @escaping ResultHandler<User>) {
        dataStore.registerUser(email: email,
                               password: password,
                               completion: completion)
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

