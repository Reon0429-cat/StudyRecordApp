//
//  HalfModalPresenter.swift
//  Half-Modal-Practice
//
//  Created by 大西玲音 on 2021/08/21.
//

import UIKit

protocol HalfModalPresenterDelegate: AnyObject {
    var halfModalContentHeight: CGFloat { get }
}

final class HalfModalPresenter: NSObject {
    
    weak var viewController: UIViewController? {
        didSet {
            if let viewController = viewController {
                viewController.modalPresentationStyle = .custom
                viewController.transitioningDelegate = self
                dismissInteractiveTransition.viewController = viewController
                dismissInteractiveTransition.addPanGesture(to: [viewController.view, indicator, overlayView])
            }
        }
    }
    private let dismissInteractiveTransition = HalfModalDismissInteractiveTransition()

    private lazy var overlayView: HalfModalOverlayView = {
        let overlayView = HalfModalOverlayView()
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(overlayViewDidTapped))
        overlayView.addGestureRecognizer(tapGR)
        return overlayView
    }()

    private lazy var indicator: HalfModalIndicatorView = {
        let indicator = HalfModalIndicatorView()
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(indicatorViewDidTapped))
        indicator.addGestureRecognizer(tapGR)
        return indicator
    }()
    
    @objc private func overlayViewDidTapped(_ sender: AnyObject) {
        viewController?.dismiss(animated: true, completion: nil)
    }

    @objc private func indicatorViewDidTapped(_ sender: AnyObject) {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension HalfModalPresenter: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfModalPresentationController(presentedViewController: presented,
                                               presenting: presenting,
                                               overlayView: overlayView,
                                               indicator: indicator)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfModalDismissAnimatedTransition()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard dismissInteractiveTransition.isInteractiveDismalTransition else { return nil }
        return dismissInteractiveTransition
    }
}
