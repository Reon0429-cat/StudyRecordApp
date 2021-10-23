//
//  HowToUseViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/22.
//

import UIKit

final class HowToUseViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    private let pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupPageControl()
        
    }
    
}

// MARK: - UIScrollViewDelegate
extension HowToUseViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
    
}

// MARK: - setup
private extension HowToUseViewController {
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(
            width: self.view.frame.maxX * CGFloat(pageSize),
            height: self.view.frame.maxY
        )
        self.view.addSubview(scrollView)
        
        for i in 0..<pageSize {
            let pageView = UIView()
            pageView.frame = CGRect(
                x: CGFloat(i) * self.view.frame.width,
                y: 0,
                width: self.view.frame.width,
                height: self.view.frame.height
            )
            scrollView.addSubview(pageView)
        }
    }
    
    func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.frame = CGRect(
            x: 0,
            y: view.frame.maxY - 115,
            width: view.frame.maxX,
            height: 50
        )
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.numberOfPages = pageSize
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
    }
    
}
