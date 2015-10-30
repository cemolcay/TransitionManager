//
//  TransitionAnimations.swift
//  TransitionManager
//
//  Created by Cem Olcay on 12/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

// MARK: TransitionManager Extension

enum TransitionManagerAnimations {
    case Fade
    case Pull
    
    func transitionAnimation () -> TransitionManagerAnimation {
        switch self {
        case .Fade:
            return FadeTransitionAnimation()
        case .Pull:
            return PullTransitionAnimation()
        }
    }
}

extension TransitionManager {
    convenience init (transition: TransitionManagerAnimations) {
        self.init (transitionAnimation: transition.transitionAnimation())
    }
}

// MARK: - Fade Transition

class FadeTransitionAnimation: TransitionManagerAnimation {
    override func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        isDismissing: Bool,
        duration: NSTimeInterval,
        completion: () -> Void) {
        if isDismissing {
            closeAnimation(container,
                fromViewController: fromViewController,
                toViewController: toViewController,
                duration: duration,
                completion: completion)
        } else {
            openAnimation(container,
                fromViewController: fromViewController,
                toViewController: toViewController,
                duration: duration,
                completion: completion)
        }
    }

    func openAnimation (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: () -> Void) {
        toViewController.view.alpha = 0
        container.addSubview(toViewController.view)
        UIView.animateWithDuration(duration,
            animations: {
                toViewController.view.alpha = 1
            }, completion: {
                finished in
                fromViewController.view.alpha = 1
                completion()
            })
    }

    func closeAnimation (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: () -> Void) {
        container.addSubview(toViewController.view)
        container.bringSubviewToFront(fromViewController.view)
        UIView.animateWithDuration(duration,
            animations: {
                fromViewController.view.alpha = 0
            }, completion: {
                finished in
                completion()
            })
    }
}

// MARK: Pull Transition

class PullTransitionAnimation: TransitionManagerAnimation {
    private weak var panningViewController: UIViewController?

    override func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        isDismissing: Bool,
        duration: NSTimeInterval,
        completion: () -> Void) {
        if isDismissing {
            closeAnimation(container,
                fromViewController: fromViewController,
                toViewController: toViewController,
                duration: duration,
                completion: completion)
        } else {
            openAnimation(container,
                fromViewController: fromViewController,
                toViewController: toViewController,
                duration: duration,
                completion: completion)
        }
    }

    func openAnimation (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: () -> Void) {
        container.addSubview(toViewController.view)
        toViewController.view.top = fromViewController.view.bottom
        toViewController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        panningViewController = toViewController
        UIView.animateWithDuration(duration,
            animations: {
                toViewController.view.top = 0
            }, completion: {
                finished in
                completion()
            })
    }

    func closeAnimation (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: () -> Void) {
        container.addSubview(toViewController.view)
        container.bringSubviewToFront(fromViewController.view)
        UIView.animateWithDuration(duration,
            animations: {
                fromViewController.view.top = toViewController.view.bottom
            }, completion: {
                finished in
                completion()
            })
    }

    func handlePan(pan: UIPanGestureRecognizer) {
        let percent = pan.translationInView(pan.view!).y / pan.view!.bounds.size.height
        switch pan.state {
        case .Began:
            interactionTransitionController = UIPercentDrivenInteractiveTransition()
            panningViewController?.dismissViewControllerAnimated(true, completion: {
                self.interactionTransitionController?.finishInteractiveTransition()
            })
        case .Changed:
            interactionTransitionController!.updateInteractiveTransition(percent)
        case .Ended:
            if percent > 0.5 {
                interactionTransitionController!.finishInteractiveTransition()
                panningViewController = nil
            } else {
                interactionTransitionController!.cancelInteractiveTransition()
            }
            interactionTransitionController = nil
        default:
            return
        }
    }
}