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
    private lazy var middleButtonView: MiddleButtonView = {
        let view = MiddleButtonView()
        view.delegate = self
        view.layer.cornerRadius = middleButtonHeight / 2
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var middleButtonBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = middleButtonBackViewHeight / 2
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let drawView: DrawView = {
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
        middleButtonBackView.addSubview(middleButtonView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [middleButtonView.heightAnchor.constraint(equalToConstant: middleButtonHeight),
         middleButtonView.widthAnchor.constraint(equalToConstant: middleButtonHeight),
         middleButtonView.centerXAnchor.constraint(equalTo: middleButtonBackView.centerXAnchor),
         middleButtonView.centerYAnchor.constraint(equalTo: middleButtonBackView.centerYAnchor),
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

extension MyTabBarController: MiddleButtonViewDelegate { } 
