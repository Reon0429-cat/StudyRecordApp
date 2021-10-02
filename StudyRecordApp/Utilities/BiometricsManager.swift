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
                return LocalizeKey.turnOnFaceID.localizedString()
            case .touchID:
                return LocalizeKey.turnOnTouchID.localizedString()
            default:
                return LocalizeKey.turnOnBiometrics.localizedString()
        }
    }
    
    func canUseBiometrics(completion: ResultHandler<Any?>) {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                     error: &error) {
            completion(.success(nil))
        } else {
            completion(.failure(""))
        }
    }
    
    func authenticate(completion: @escaping ResultHandler<Any?>) {
        let localizedReason = LocalizeKey.useAuthenticationToUnlock.localizedString()
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
                completion(.failure(LocalizeKey.unknownError.localizedString()))
            }
        }
    }
    
}
