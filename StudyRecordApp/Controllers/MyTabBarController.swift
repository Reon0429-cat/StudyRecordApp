//
//  MyTabBarController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

class MyTabBarController: UIViewController {
    
    private let middleButtonHeight: CGFloat = 80
    private lazy var middleButtonView: MiddleButtonView = {
        let view = MiddleButtonView()
        view.delegate = self
        view.layer.cornerRadius = middleButtonHeight / 2
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let middleTabBarBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let rightTabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let leftTabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var drawViews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<50 {
            var drawView = UIView()
            drawView = (i == 0) ? DrawView() : SubDrawView()
            drawView.backgroundColor = .clear
            drawView.translatesAutoresizingMaskIntoConstraints = false
            self.view.insertSubview(drawView, aboveSubview: self.view)
            drawViews.append(drawView)
        }
        self.view.addSubview(middleButtonView)
        self.view.addSubview(middleTabBarBottomView)
        self.view.addSubview(rightTabBarView)
        self.view.addSubview(leftTabBarView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let middleButtonBackViewHeight = middleButtonHeight + 20
        
        drawViews.enumerated().forEach { i, drawView in
            [drawView.widthAnchor.constraint(equalToConstant: middleButtonBackViewHeight),
             drawView.heightAnchor.constraint(equalToConstant: middleButtonBackViewHeight - CGFloat(i)),
             drawView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
             drawView.topAnchor.constraint(equalTo: middleButtonView.centerYAnchor, constant: CGFloat(i)),
            ].forEach { $0.isActive = true }
        }
        
        [middleButtonView.widthAnchor.constraint(equalToConstant: middleButtonHeight),
         middleButtonView.heightAnchor.constraint(equalToConstant: middleButtonHeight),
         middleButtonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
         middleButtonView.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -middleButtonHeight),
        ].forEach { $0.isActive = true }
        
        [middleTabBarBottomView.widthAnchor.constraint(equalToConstant: middleButtonBackViewHeight),
         middleTabBarBottomView.heightAnchor.constraint(equalToConstant: middleButtonHeight - middleButtonBackViewHeight / 2 - 2),
         middleTabBarBottomView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
         middleTabBarBottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ].forEach { $0.isActive = true }
        
        [rightTabBarView.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width - middleButtonBackViewHeight) / 2),
         rightTabBarView.heightAnchor.constraint(equalToConstant: middleButtonHeight),
         rightTabBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
         rightTabBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ].forEach { $0.isActive = true }
        
        [leftTabBarView.widthAnchor.constraint(equalToConstant: (self.view.frame.size.width - middleButtonBackViewHeight) / 2),
         leftTabBarView.heightAnchor.constraint(equalToConstant: middleButtonHeight),
         leftTabBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
         leftTabBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ].forEach { $0.isActive = true }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        rightTabBarView.addBorder(width: 0.5, color: .black, position: .top)
        leftTabBarView.addBorder(width: 0.5, color: .black, position: .top)
        
    }
    
    @objc private func middleButtonDidTapped() {
        print(#function)
    }
    
}

extension MyTabBarController: MiddleButtonViewDelegate { }
