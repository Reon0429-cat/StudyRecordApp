//
//  MyTabBarController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        setupMiddleButton()
        
    }
    
    private func setupMiddleButton() {
        let height: CGFloat = 100
        let button = UIButton()
        button.layer.cornerRadius = height / 2
        button.addTarget(self, action: #selector(middleButtonDidTapped), for: .touchUpInside)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(button, aboveSubview: tabBar)
        [button.heightAnchor.constraint(equalToConstant: height),
         button.widthAnchor.constraint(equalToConstant: height),
         button.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
         button.centerYAnchor.constraint(equalTo: tabBar.topAnchor),
        ].forEach { $0.isActive = true }
    }
    
    @objc private func middleButtonDidTapped() {
        print(#function)
    }
    
}

extension MyTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(#function)
    }
}
