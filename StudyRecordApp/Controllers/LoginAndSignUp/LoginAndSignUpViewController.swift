//
//  LoginAndSignUpViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit

final class LoginAndSignUpViewController: UIViewController {
    
    @IBOutlet private weak var loginContainerView: UIView!
    @IBOutlet private weak var signUpContainerView: UIView!
    @IBOutlet private weak var loginToggleView: UIView!
    @IBOutlet private weak var signUpToggleView: UIView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var signUpLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    private enum ViewType {
        case login
        case signUp
    }
    private var viewType: ViewType = .login {
        didSet {
            bringContainerView()
            setToggleViewColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewType = .login
        setupToggleViews()
        
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
                loginToggleView.backgroundColor = .systemRed
                signUpToggleView.backgroundColor = .clear
                loginLabel.textColor = .black
                signUpLabel.textColor = .gray
            case .signUp:
                loginToggleView.backgroundColor = .clear
                signUpToggleView.backgroundColor = .systemGreen
                loginLabel.textColor = .gray
                signUpLabel.textColor = .black
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
    
    func setupToggleViews() {
        let loginTapGR = UITapGestureRecognizer(target: self,
                                                action: #selector(loginBackViewDidTapped))
        self.loginToggleView.addGestureRecognizer(loginTapGR)
        let signUpTapGR = UITapGestureRecognizer(target: self,
                                                 action: #selector(signUpBackViewDidTapped))
        self.signUpToggleView.addGestureRecognizer(signUpTapGR)
    }
    
    @objc
    func loginBackViewDidTapped() {
        viewType = .login
    }
    
    @objc
    func signUpBackViewDidTapped() {
        viewType = .signUp
    }
    
}
