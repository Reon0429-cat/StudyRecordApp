//
//  UserRepositoryProtocol.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
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
