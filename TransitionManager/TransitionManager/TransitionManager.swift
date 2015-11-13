//
//  TransitionManager.swift
//  Transition
//
//  Created by Cem Olcay on 12/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

protocol TransitionManagerDelegate {

    /// Transition animation method implementation
    func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        isDismissing: Bool,
        duration: NSTimeInterval,
        completion: () -> Void)

    /// Interactive transitions,
    /// update percent in gesture handler
    var interactionTransitionController: UIPercentDrivenInteractiveTransition? { get set }
}

class TransitionManagerAnimation: NSObject, TransitionManagerDelegate {

    // MARK: TransitionManagerDelegate

    func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        isDismissing: Bool,
        duration: NSTimeInterval,
        completion: () -> Void) {
        completion()
    }

    private var _interactionTransitionController: UIPercentDrivenInteractiveTransition? = nil
    var interactionTransitionController: UIPercentDrivenInteractiveTransition? {
        get {
            return _interactionTransitionController
        } set {
            _interactionTransitionController = newValue
        }
    }
}

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    // MARK: Properties

    private var transitionAnimation: TransitionManagerAnimation!
    private var isDismissing: Bool = false
    private var duration: NSTimeInterval = 0.30

    // MARK: Lifecycle

    init (transitionAnimation: TransitionManagerAnimation) {
        self.transitionAnimation = transitionAnimation
    }

    // MARK: UIViewControllerAnimatedTransitioning

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        transitionAnimation.transition(
        container!,
        fromViewController: fromViewController!,
        toViewController: toViewController!,
        isDismissing: isDismissing,
        duration: transitionDuration(transitionContext),
        completion: {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }

    // MARK: UIViewControllerTransitioningDelegate

    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            isDismissing = false
            return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            isDismissing = true
            return self
    }

    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        isDismissing = false
        return transitionAnimation.interactionTransitionController
    }

    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        isDismissing = true
        return transitionAnimation.interactionTransitionController
    }

    // MARK: UINavigationControllerDelegate

    func navigationController(
        navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func navigationController(
        navigationController: UINavigationController,
        interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitionAnimation.interactionTransitionController
    }
}
