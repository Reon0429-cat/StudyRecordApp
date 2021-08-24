//
//  HalfModalPresentationController.swift
//  Half-Modal-Practice
//
//  Created by 大西玲音 on 2021/08/21.
//

import UIKit

final class HalfModalPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView.bounds
        presentedViewFrame.size = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width
        presentedViewFrame.origin.y = containerBounds.size.height - presentedViewFrame.size.height
        return presentedViewFrame
    }

    private let overlay: HalfModalOverlayView
    private let indicator: HalfModalIndicatorView
    private let presentedViewControllerHeightRatio: CGFloat = 0.5
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         overlayView: HalfModalOverlayView,
         indicator: HalfModalIndicatorView) {
        self.overlay = overlayView
        self.indicator = indicator
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
    }

    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        if let delegate = presentedViewController as? HalfModalPresenterDelegate {
            return CGSize(width: parentSize.width,
                          height: delegate.halfModalContentHeight)
        }
        return CGSize(width: parentSize.width,
                      height: parentSize.height * self.presentedViewControllerHeightRatio)
    }

    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else { return }
        overlay.frame = containerView.bounds
        containerView.insertSubview(overlay, at: 0)
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 8)
        presentedViewController.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: presentedViewController.view.centerXAnchor),
            indicator.topAnchor.constraint(equalTo: presentedViewController.view.topAnchor, constant: -16),
            indicator.widthAnchor.constraint(equalToConstant: indicator.frame.width),
            indicator.heightAnchor.constraint(equalToConstant: indicator.frame.height)
        ])
    }

    override func presentationTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate { _ in
            self.overlay.isActive = true
        }
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate { _ in
            self.overlay.isActive = false
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            overlay.removeFromSuperview()
        }
    }
    
}
