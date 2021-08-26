//
//  LoginAndSignUpViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit

// MARK: - ToDo 横スワイプでもログインとサインアップを切り替えられるようにする

final class LoginAndSignUpViewController: UIViewController {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var loginContainerView: UIView!
    @IBOutlet private weak var signUpContainerView: UIView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    
    private enum ViewType {
        case login
        case signUp
    }
    private var viewType: ViewType = .login {
        didSet {
            bringContainerView()
            setToggleViewColor()
            setContainerViewCorners()
        }
    }
    private let cornerRadiusConstant: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewType = .login
        setupBaseView()
        setupLoginButton()
        setupSignUpButton()
        
    }
    
    @IBAction private func loginButtonDidTapped(_ sender: Any) {
        viewType = .login
    }
    
    @IBAction private func signUpButtonDidTapped(_ sender: Any) {
        viewType = .signUp
    }
    
    private func bringContainerView() {
        switch viewType {
            case .login:
                containerView.bringSubviewToFront(loginContainerView)
            case .signUp:
                containerView.bringSubviewToFront(signUpContainerView)
        }
    }
    
    private func setToggleViewColor() {
        switch viewType {
            case .login:
                loginButton.backgroundColor = .systemRed
                signUpButton.backgroundColor = .clear
                loginButton.tintColor = .black
                signUpButton.tintColor = .gray
            case .signUp:
                loginButton.backgroundColor = .clear
                signUpButton.backgroundColor = .systemGreen
                loginButton.tintColor = .gray
                signUpButton.tintColor = .black
        }
    }
    
    private func setContainerViewCorners() {
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch viewType {
//            case .login:
//                let loginVC = segue.destination as! LoginViewController
//
//            case .signUp:
//                let signUpVC = segue.destination as! SignUpViewController
//        }
//    }
    
}

// MARK: - setup
private extension LoginAndSignUpViewController {
    
    func setupBaseView() {
        baseView.setShadow()
    }
    
    func setupLoginButton() {
        loginButton.layer.cornerRadius = cornerRadiusConstant
        loginButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupSignUpButton() {
        signUpButton.layer.cornerRadius = cornerRadiusConstant
        signUpButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}

private extension UIView {
    
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.6
    }
    
}
