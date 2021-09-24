//
//  RxFirebaseUserDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import FirebaseAuth

protocol RxUserDataStoreProtocol {
    var currentUser: User? { get }
    func login(email: String,
               password: String,
               completion: @escaping (Result<Any?, Error>) -> Void)
}

final class RxFirebaseUserDataStore: RxUserDataStoreProtocol {
    
    var currentUser: User? {
        return User()
    }
    
    func login(email: String,
               password: String,
               completion: @escaping (Result<Any?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(nil))
        }
    }
    
    private func authErrorMessage(_ error: Error) -> String {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
                case .invalidEmail:
                    return LocalizeKey.theEmailAddressFormatContainsAnError.localizedString()
                case .weakPassword:
                    return LocalizeKey.pleaseEnterThePasswordWithAtLeast6Characters.localizedString()
                case .wrongPassword:
                    return LocalizeKey.thePasswordIsIncorrect.localizedString()
                case .userNotFound:
                    return LocalizeKey.thisEmailAddressIsNotRegistered.localizedString()
                case .emailAlreadyInUse:
                    return LocalizeKey.thisEmailAddressIsAlreadyRegistered.localizedString()
                default:
                    return LocalizeKey.loginFailed.localizedString() + "\(error.localizedDescription)"
            }
        }
        return LocalizeKey.anUnknownErrorHasOccurred.localizedString()
    }
    
}

private extension User {
    
    init?() {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        self.id = user.uid
    }
    
}
