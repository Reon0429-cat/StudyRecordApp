//
//  LoginAndSignUpViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit
import SwiftUI

final class LoginAndSignUpViewController: UIViewController {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var loginContainerView: UIView!
    @IBOutlet private weak var signUpContainerView: UIView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    
    enum AuthViewType {
        case login
        case signUp
    }
    var authViewType: AuthViewType = .login
    private let cornerRadiusConstant: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBaseView()
        setupLoginButton()
        setupSignUpButton()
        changeViewType(authViewType)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch StoryboardSegue.LoginAndSignUp(segue) {
            case .loginSegueId:
                let loginVC = segue.destination as! LoginViewController
                loginVC.delegate = self
            case .signUpSegueId:
                let signUpVC = segue.destination as! SignUpViewController
                signUpVC.delegate = self
            default:
                break
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setBaseViewLayerColor()
        }
    }
    
}

// MARK: - IBAction func
private extension LoginAndSignUpViewController {
    
    @IBAction func loginButtonDidTapped(_ sender: Any) {
        changeViewType(.login)
    }
    
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        changeViewType(.signUp)
    }
    
}

// MARK: - func
private extension LoginAndSignUpViewController {
    
    func changeViewType(_ viewType: AuthViewType) {
        bringContainerView(viewType)
        setToggleViewColor(viewType)
        setContainerViewCorners(viewType)
    }
    
    func bringContainerView(_ viewType: AuthViewType) {
        switch viewType {
            case .login:
                containerView.bringSubviewToFront(loginContainerView)
            case .signUp:
                containerView.bringSubviewToFront(signUpContainerView)
        }
    }
    
    func setToggleViewColor(_ viewType: AuthViewType) {
        switch viewType {
            case .login:
                loginButton.backgroundColor = .dynamicColor(light: .white, dark: .secondarySystemBackground)
                signUpButton.backgroundColor = .dynamicColor(light: .clear, dark: .clear)
                loginButton.tintColor = .dynamicColor(light: .black, dark: .white)
                signUpButton.tintColor = .dynamicColor(light: .gray, dark: .gray)
            case .signUp:
                loginButton.backgroundColor = .dynamicColor(light: .clear, dark: .clear)
                signUpButton.backgroundColor = .dynamicColor(light: .white, dark: .secondarySystemBackground)
                loginButton.tintColor = .dynamicColor(light: .gray, dark: .gray)
                signUpButton.tintColor = .dynamicColor(light: .black, dark: .white)
        }
    }
    
    func setContainerViewCorners(_ viewType: AuthViewType) {
        switch viewType {
            case .login:
                containerView.layer.cornerRadius = cornerRadiusConstant
                containerView.layer.maskedCorners = [.layerMaxXMinYCorner,
                                                     .layerMinXMaxYCorner,
                                                     .layerMaxXMaxYCorner]
                containerView.layer.masksToBounds = true
            case .signUp:
                containerView.layer.cornerRadius = cornerRadiusConstant
                containerView.layer.maskedCorners = [.layerMinXMinYCorner,
                                                     .layerMinXMaxYCorner,
                                                     .layerMaxXMaxYCorner]
                containerView.layer.masksToBounds = true
        }
    }
    
    func setBaseViewLayerColor() {
        baseView.setShadow(color: .dynamicColor(light: .black,
                                                dark: .white),
                           radius: 5,
                           opacity: 0.6,
                           size: (width: 3,
                                  height: 3))
    }
    
}

// MARK: - LoginVCDelegate
extension LoginAndSignUpViewController: LoginVCDelegate {
    
    func leftSwipeDid() {
        changeViewType(.signUp)
    }
    
}

// MARK: - SignUpVCDelegate
extension LoginAndSignUpViewController: SignUpVCDelegate {
    
    func rightSwipeDid() {
        changeViewType(.login)
    }
    
}

// MARK: - setup
private extension LoginAndSignUpViewController {
    
    func setupBaseView() {
        setBaseViewLayerColor()
    }
    
    func setupLoginButton() {
        loginButton.layer.cornerRadius = cornerRadiusConstant
        loginButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        loginButton.setTitle(L10n.login)
        loginButton.backgroundColor = .dynamicColor(light: .white,
                                                    dark: .secondarySystemBackground)
    }
    
    func setupSignUpButton() {
        signUpButton.layer.cornerRadius = cornerRadiusConstant
        signUpButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        signUpButton.setTitle(L10n.signUp)
        signUpButton.backgroundColor = .clear
    }
    
}
