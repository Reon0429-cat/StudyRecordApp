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

enum Result<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

typealias ResultHandler<T> = (Result<T, String>) -> Void

protocol UserDataStoreProtocol {
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

final class FirebaseUserDataStore: UserDataStoreProtocol {

    var currentUser: User? {
        return User()
    }

    func registerUser(email: String,
                      password: String,
                      completion: @escaping ResultHandler<User>) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            if let error = error {
                let message = self.authErrorMessage(error)
                completion(.failure(message))
                return
            }
            if let user = result?.user {
                let user = User(id: user.uid, isAnonymous: false)
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

    func logout(completion: @escaping ResultHandler<Any?>) {
        do {
            try Auth.auth().signOut()
            completion(.success(nil))
        } catch {
            let message = authErrorMessage(error)
            completion(.failure(message))
        }
    }

    func sendPasswordResetMail(email: String,
                               completion: @escaping ResultHandler<Any?>) {
        Auth.auth().languageCode = L10n.languageCode
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                let message = self.authErrorMessage(error)
                completion(.failure(message))
                return
            }
            completion(.success(nil))
        }
    }

    func signInAnonymously(completion: @escaping ResultHandler<Any?>) {
        Auth.auth().signInAnonymously { _, error in
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
                return L10n.loginFailed + "\(error.localizedDescription)"
            }
        }
        return L10n.anUnknownErrorHasOccurred
    }

}

private extension User {

    init?() {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        self.id = user.uid
        self.isAnonymous = user.isAnonymous
    }

}
