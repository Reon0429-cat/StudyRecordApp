//
//  UserUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/28.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

typealias ResultHandler<T> = (Result<T, Error>) -> Void

final class UserUseCase {
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    func registerUser(email: String,
                      password: String,
                      completion: @escaping ResultHandler<Firebase.User>) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let user = result?.user {
                    completion(.success(user))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func createUser(userId: String,
                    email: String,
                    completion: @escaping ResultHandler<Any?>) {
        let userRef = Firestore.firestore().collection("users")
        userRef.document(userId).setData(["mail": email]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(nil))
            }
        }
    }
    
}
