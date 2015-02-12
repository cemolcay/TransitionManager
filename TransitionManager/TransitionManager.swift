//
//  TransitionManager.swift
//  Transition
//
//  Created by Mathew Sanders on 9/6/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import UIKit

protocol TransitionManagerDelegate {
    
    func transition (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: ()->Void)
    
    func interactionTransition (interactionController: UIPercentDrivenInteractiveTransition?) -> UIPercentDrivenInteractiveTransition?
}

class TransitionManagerAnimation: TransitionManagerDelegate {
    
    // MARK: Lifecycle
    
    init () {}
    
    
    // MARK: TransitionManagerDelegate
    
    func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: () -> Void) {
            
        completion()
    }
    
    func interactionTransition(interactionController: UIPercentDrivenInteractiveTransition?) -> UIPercentDrivenInteractiveTransition? {
        return interactionController
    }
}

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    var interactionController: UIPercentDrivenInteractiveTransition?

    var transitionAnimation: TransitionManagerAnimation!
    let duration: NSTimeInterval = 0.70
    
    
    
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
            container,
            fromViewController: fromViewController!,
            toViewController: toViewController!,
            duration: transitionDuration(transitionContext),
            completion: {
                transitionContext.completeTransition(true)
            })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
    
    
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return self
    }
    
    func animationControllerForDismissedController(
        dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitionAnimation.interactionTransition(interactionController)
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitionAnimation.interactionTransition(interactionController)
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
        return transitionAnimation.interactionTransition(interactionController)
    }
}
