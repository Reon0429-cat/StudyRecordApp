//
//  SceneDelegate.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private var userUseCase = UserUseCase(
        repository: UserRepository(
            dataStore: FirebaseUserDataStore()
        )
    )
    private var settingUseCase = SettingUseCase(
        repository: SettingRepository(
            dataStore: RealmSettingDataStore()
        )
    )
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        if userUseCase.isLoggedIn {
            if settingUseCase.setting.isPasscodeSetted {
                window.setRootVC(PasscodeViewController.self) { vc in
                    vc.passcodeMode = .certification
                }
            } else {
                window.setRootVC(TopViewController.self)
            }
        } else {
            window.setRootVC(LoginAndSignUpViewController.self)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(brightnessDidChanged),
                                               name: .brightnessDidChanged,
                                               object: nil)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if userUseCase.isLoggedIn {
            if settingUseCase.setting.isPasscodeSetted {
                self.window?.setRootVC(PasscodeViewController.self) { vc in
                    vc.passcodeMode = .certification
                }
            }
        } else {
            self.window?.setRootVC(LoginAndSignUpViewController.self)
        }
    }
    
    @objc
    private func brightnessDidChanged(notification: Notification) {
        guard let mode = notification.userInfo?["mode"] as? UIUserInterfaceStyle else { return }
        self.window?.overrideUserInterfaceStyle = mode
    }
    
}

private extension UIWindow {
    
    func setRootVC<T: UIViewController>(_ ViewControllerType: T.Type,
                                        handler: ((T) -> Void)? = nil) {
        let vc = ViewControllerType.instantiate()
        handler?(vc)
        self.rootViewController = vc
    }
    
}
