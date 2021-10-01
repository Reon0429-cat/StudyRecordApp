//
//  BiometricsManager.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/01.
//

import Foundation
import LocalAuthentication

final class BiometricsManager {
    
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
            completion(.failure(LocalizeKey.pleaseAllowBiometrics.localizedString()))
        }
    }
    
    func authenticate(completion: @escaping ResultHandler<Bool>) {
        let localizedReason = LocalizeKey.useAuthenticationToUnlock.localizedString()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: localizedReason) { isSuccess, error in
//            if let error = error {
//                switch LAError(_nsError: error as NSError).code {
//                    case .appCancel:
//                        // システムによるキャンセル① アプリのコード
//                    case .systemCancel:
//                        // システムによるキャンセル② システム
//                    case .userCancel:
//                        // ユーザーによってキャンセルされた場合
//                    case .biometryLockout:
//                        // 生体認証エラー① 失敗制限に達した際のロック
//                    case .biometryNotAvailable:
//                        // 生体認証エラー② 許可していない
//                    case .biometryNotEnrolled:
//                        // 生体認証エラー③ 生体認証IDが１つもない
//                    case .authenticationFailed:
//                        // 認証に失敗してエラー
//                    case .invalidContext:
//                        // システムによるエラー① すでに無効化済み
//                    case .notInteractive:
//                        // システムによるエラー② 非表示になっている
//                    case .passcodeNotSet:
//                        // パスコード認証エラー① パスコードを設定していない
//                    case .userFallback:
//                        // パスコード認証エラー② LAPolicyによって無効化
//                    default:
//                        // そのほかの未対応エラー
//                }
//                return
//            }
//            if isSuccess {
//                completion(.success(isSuccess))
//            } else {
//                completion(.failure("予期せぬエラー"))
//            }
        }
    }
    
}
