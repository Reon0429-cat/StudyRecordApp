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

enum Result<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

typealias ResultHandler<T> = (Result<T, String>) -> Void

final class UserUseCase {
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    func registerUser(email: String,
                      password: String,
                      completion: @escaping ResultHandler<Firebase.User>) {
        if password.count < 6 {
            completion(.failure("パスワードは６文字以上で入力してください"))
            return
        }
        if password.contains(" ") {
            completion(.failure("パスワードに空白が含まれています"))
            return
        }
        if email == self.currentUser?.email ?? "" {
            completion(.failure("このメールアドレスは既に登録されています"))
            return
        }
        if email.contains(" ") {
            completion(.failure("メールアドレスに空白が含まれています"))
            return
        }
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            if let error = error {
                completion(.failure(error.localizedDescription))
            } else {
                if let user = result?.user {
                    completion(.success(user))
                } else if let error = error {
                    completion(.failure(error.localizedDescription))
                }
            }
        }
    }
    
    func createUser(userId: String,
                    email: String,
                    completion: @escaping ResultHandler<Any?>) {
        let userRef = Firestore.firestore().collection("users")
        let data = [String: Any]()
        userRef.document(userId).setData(data) { error in
            if let error = error {
                completion(.failure(error.localizedDescription))
            } else {
                completion(.success(nil))
            }
        }
    }
    
}
