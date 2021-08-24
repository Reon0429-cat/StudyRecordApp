//
//  HalfModalDismissAnimatedTransition.swift
//  Half-Modal-Practice
//
//  Created by 大西玲音 on 2021/08/21.
//

import UIKit

final class HalfModalDismissAnimatedTransition: NSObject {
    
}

extension HalfModalDismissAnimatedTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut) {
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            fromView.center.y = UIScreen.main.bounds.size.height + fromView.bounds.height / 2
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
