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
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            if let error = error {
                let message = self.authErrorMessage(error)
                completion(.failure(message))
                return
            }
            if let user = result?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error.localizedDescription))
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
                return
            }
            completion(.success(nil))
        }
    }
    
    func login(email: String,
               password: String,
               completion: @escaping ResultHandler<Any?>) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { _, error in
            if let error = error {
                let message = self.authErrorMessage(error)
                completion(.failure(message))
                return
            }
            completion(.success(nil))
        }
    }
    
    private func authErrorMessage(_ error: Error) -> String {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
                case .invalidEmail: return "メールアドレスの形式に誤りが含まれます。"
                case .weakPassword: return "パスワードは６文字以上で入力してください。"
                case .wrongPassword: return "パスワードに誤りがあります。"
                case .userNotFound: return "こちらのメールアドレスは登録されていません。"
                case .emailAlreadyInUse: return "こちらのメールアドレスは既に登録されています。"
                default: return "ログインに失敗しました\(error)"
            }
        }
        return "不明なエラーが発生しました。"
    }
    
}
