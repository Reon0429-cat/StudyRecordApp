//
//  MyTabBarController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

final class MyTabBarController: UITabBarController {
    
    private let middleButtonHeight: CGFloat = 80
    private var middleButtonBackViewHeight: CGFloat { middleButtonHeight + 20 }
    private lazy var middleButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = middleButtonHeight / 2
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var middleButtonBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = middleButtonBackViewHeight / 2
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var drawView: DrawView = {
        let view = DrawView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        self.view.insertSubview(middleButtonBackView, aboveSubview: tabBar)
        middleButtonBackView.addSubview(drawView)
        middleButtonBackView.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(middleButtonDidTapped), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [middleButton.heightAnchor.constraint(equalToConstant: middleButtonHeight),
         middleButton.widthAnchor.constraint(equalToConstant: middleButtonHeight),
         middleButton.centerXAnchor.constraint(equalTo: middleButtonBackView.centerXAnchor),
         middleButton.centerYAnchor.constraint(equalTo: middleButtonBackView.centerYAnchor),
        ].forEach { $0.isActive = true }
        
        [middleButtonBackView.heightAnchor.constraint(equalToConstant: middleButtonBackViewHeight),
         middleButtonBackView.widthAnchor.constraint(equalToConstant: middleButtonBackViewHeight),
         middleButtonBackView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
         middleButtonBackView.centerYAnchor.constraint(equalTo: tabBar.topAnchor),
        ].forEach { $0.isActive = true }
        
        [drawView.heightAnchor.constraint(equalToConstant: middleButtonBackViewHeight),
         drawView.widthAnchor.constraint(equalToConstant: middleButtonBackViewHeight),
         drawView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
         drawView.topAnchor.constraint(equalTo: tabBar.topAnchor)
        ].forEach { $0.isActive = true }
        
    }
    
    @objc private func middleButtonDidTapped() {
        print(#function)
    }
    
}

extension MyTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        print(#function)
    }
    
}
