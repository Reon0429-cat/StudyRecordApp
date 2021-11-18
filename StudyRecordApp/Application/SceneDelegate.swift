//
//  SceneDelegate.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit
import RxSwift
import RxCocoa

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let userUseCase = UserUseCase(
        repository: UserRepository()
    )
    private let settingUseCase = SettingUseCase(
        repository: SettingRepository()
    )
    private let disposeBag = DisposeBag()

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        userUseCase.isLoggedIn
            .subscribe(onSuccess: { [weak self] isLoggedIn in
                guard let self = self else { return }
                if isLoggedIn {
                    if self.settingUseCase.setting.isPasscodeSetted {
                        window.setRootVC(PasscodeViewController.self) { vc in
                            vc.passcodeMode = .certification
                        }
                    } else {
                        window.setRootVC(TopViewController.self)
                    }
                } else {
                    window.setRootVC(LoginAndSignUpViewController.self)
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(brightnessDidChanged),
                                               name: .brightnessDidChanged,
                                               object: nil)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        switch settingUseCase.setting.darkModeSettingType {
        case .app:
            let mode: UIUserInterfaceStyle = settingUseCase.setting.isDarkMode ? .dark : .light
            self.window?.overrideUserInterfaceStyle = mode
        case .auto:
            let mode = UITraitCollection.current.userInterfaceStyle
            self.window?.overrideUserInterfaceStyle = mode
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        userUseCase.isLoggedIn
            .subscribe(onSuccess: { [weak self] isLoggedIn in
                guard let self = self else { return }
                if isLoggedIn {
                    if self.settingUseCase.setting.isPasscodeSetted {
                        self.window?.setRootVC(PasscodeViewController.self) { vc in
                            vc.passcodeMode = .certification
                        }
                    }
                } else {
                    self.window?.setRootVC(LoginAndSignUpViewController.self)
                }
            })
            .disposed(by: disposeBag)
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
