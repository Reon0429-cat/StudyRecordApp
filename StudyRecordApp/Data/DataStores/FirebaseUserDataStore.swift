//
//  FirebaseUserDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/29.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

typealias ResultHandler<T> = (Result<T, Error>) -> Void

final class FirebaseUserDataStore {

    var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }

    func registerUser(email: String,
                      password: String,
                      completion: @escaping ResultHandler<FirebaseAuth.User>) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let user = result?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
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
                completion(.failure(error))
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
                completion(.failure(error))
                return
            }
            completion(.success(nil))
        }
    }

    func logout(completion: @escaping ResultHandler<Any?>) {
        do {
            try Auth.auth().signOut()
            completion(.success(nil))
        } catch {
            completion(.failure(error))
        }
    }

    func sendPasswordResetMail(email: String,
                               completion: @escaping ResultHandler<Any?>) {
        Auth.auth().languageCode = L10n.languageCode
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(nil))
        }
    }

    func signInAnonymously(completion: @escaping ResultHandler<Any?>) {
        Auth.auth().signInAnonymously { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(nil))
        }
    }

}

extension Error {

    var toAuthErrorMessage: String {
        if let errorCode = AuthErrorCode(rawValue: self._code) {
            switch errorCode {
            case .invalidEmail:
                return L10n.theEmailAddressFormatContainsAnError
            case .weakPassword:
                return L10n.pleaseEnterThePasswordWithAtLeast6Characters
            case .wrongPassword:
                return L10n.thePasswordIsIncorrect
            case .userNotFound:
                return L10n.thisEmailAddressIsNotRegistered
            case .emailAlreadyInUse:
                return L10n.thisEmailAddressIsAlreadyRegistered
            case .adminRestrictedOperation:
                return L10n.adminRestrictedOperation
            default:
                return L10n.loginFailed + "\(self.localizedDescription)"
            }
        }
        return L10n.anUnknownErrorHasOccurred
    }

}
