//
//  LoginAndSignUpViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit

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
    private func convertToViewTypeFrom(_ id: String) -> ViewType {
        switch id {
            case "loginSegueId": return .login
            case "signUpSegueId": return .signUp
            default: fatalError("予期しないidがあります。")
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        let viewType = convertToViewTypeFrom(segueId)
        switch viewType {
            case .login:
                let loginVC = segue.destination as! LoginViewController
                loginVC.delegate = self
            case .signUp:
                let signUpVC = segue.destination as! SignUpViewController
                signUpVC.delegate = self
        }
    }
    
}

// MARK: - IBAction func
private extension LoginAndSignUpViewController {
    
    @IBAction func loginButtonDidTapped(_ sender: Any) {
        viewType = .login
    }
    
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        viewType = .signUp
    }
    
}

// MARK: - func
private extension LoginAndSignUpViewController {
    
    func bringContainerView() {
        switch viewType {
            case .login:
                containerView.bringSubviewToFront(loginContainerView)
            case .signUp:
                containerView.bringSubviewToFront(signUpContainerView)
        }
    }
    
    func setToggleViewColor() {
        switch viewType {
            case .login:
                loginButton.backgroundColor = .white
                signUpButton.backgroundColor = .clear
                loginButton.tintColor = .black
                signUpButton.tintColor = .gray
            case .signUp:
                loginButton.backgroundColor = .clear
                signUpButton.backgroundColor = .white
                loginButton.tintColor = .gray
                signUpButton.tintColor = .black
        }
    }
    
    func setContainerViewCorners() {
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
    
}

// MARK: - setup
private extension LoginAndSignUpViewController {
    
    func setupBaseView() {
        baseView.setShadow(radius: 5, opacity: 0.6, size: (width: 3, height: 3))
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

// MARK: - LoginVCDelegate
extension LoginAndSignUpViewController: LoginVCDelegate {
    
    func leftSwipeDid() {
        viewType = .signUp
    }
    
}

// MARK: - SignUpVCDelegate
extension LoginAndSignUpViewController: SignUpVCDelegate {
    
    func rightSwipeDid() {
        viewType = .login
    }
    
}

