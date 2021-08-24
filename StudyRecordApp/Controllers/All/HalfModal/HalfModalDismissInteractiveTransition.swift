//
//  HalfModalDismissInteractiveTransition.swift
//  Half-Modal-Practice
//
//  Created by 大西玲音 on 2021/08/21.
//

import UIKit

final class HalfModalDismissInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    weak var viewController: UIViewController?
    private(set) var isInteractiveDismalTransition = false
    private let percentCompleteThreshold: CGFloat = 0.3
    private var gestureDirection: GestureDirection = .down
    private enum GestureDirection {
        case up
        case down
        
        init(recognizer: UIPanGestureRecognizer, view: UIView) {
            let velocity = recognizer.velocity(in: view)
            self = velocity.y <= 0 ? .up : .down
        }
    }
    
    override func cancel() {
        completionSpeed = self.percentCompleteThreshold
        super.cancel()
    }
    
    override func finish() {
        completionSpeed = 1 - self.percentCompleteThreshold
        super.finish()
    }
    
    func addPanGesture(to views: [UIView]) {
        views.forEach {
            let panGR = UIPanGestureRecognizer(target: self,
                                               action: #selector(dismiss))
            panGR.delegate = self
            $0.addGestureRecognizer(panGR)
        }
    }
    
    @objc private func dismiss(recognizer: UIPanGestureRecognizer) {
        guard let viewController = viewController else { return }
        isInteractiveDismalTransition = (recognizer.state == .began || recognizer.state == .changed)
        switch recognizer.state {
            case .began:
                gestureDirection = GestureDirection(recognizer: recognizer, view: viewController.view)
                if gestureDirection == .down {
                    viewController.dismiss(animated: true, completion: nil)
                }
            case .changed:
                let progress: CGFloat = {
                    let translation = recognizer.translation(in: viewController.view)
                    let _progress = translation.y / viewController.view.bounds.size.height
                    switch gestureDirection {
                        case .up:
                            return -max(-1.0, max(-1.0, _progress))
                        case .down:
                            return min(1.0, max(0, _progress))
                    }
                }()
                update(progress)
            case .cancelled, .ended:
                (percentComplete > percentCompleteThreshold) ?  finish() : cancel()
            default:
                break
        }
    }
}

extension HalfModalDismissInteractiveTransition: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIPanGestureRecognizer)
    }
    
}
