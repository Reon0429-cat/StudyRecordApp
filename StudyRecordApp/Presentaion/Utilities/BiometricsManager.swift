//
//  BiometricsManager.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/01.
//

import Foundation
import LocalAuthentication

struct BiometricsManager {

    private var context: LAContext {
        let context = LAContext()
        context.localizedFallbackTitle = ""
        return context
    }

    var title: String {
        switch context.biometryType {
        case .faceID:
            return L10n.turnOnFaceID
        case .touchID:
            return L10n.turnOnTouchID
        default:
            return L10n.turnOnBiometrics
        }
    }

    enum Result<Success, String> {
        case success(Success)
        case failure(String)
    }

    func canUseBiometrics(completion: @escaping (Result<Any?, String>) -> Void) {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                     error: &error) {
            completion(.success(nil))
        } else {
            completion(.failure(""))
        }
    }

    func authenticate(completion: @escaping (Result<Any?, String>) -> Void) {
        let localizedReason = L10n.useAuthenticationToUnlock
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: localizedReason) { isSuccess, error in
            if let error = error {
                switch LAError(_nsError: error as NSError).code {
                default:
                    break
                }
                return
            }
            if isSuccess {
                completion(.success(nil))
            } else {
                completion(.failure(L10n.unknownError))
            }
        }
    }

}
