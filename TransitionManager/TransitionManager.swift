//
//  TransitionManager.swift
//  Transition
//
//  Created by Mathew Sanders on 9/6/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import UIKit


// MARK: - Transition Animations

class FadeTransitionAnimation: TransitionManagerAnimation {
    
    override func transition (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: ()->Void) {
            
        let fromView = fromViewController.view
        let toView = toViewController.view

        container.addSubview(toView)
        toView.alpha = 0
            
        UIView.animateWithDuration(
            duration,
            animations: {
                toView.alpha = 1
            },
            completion: { finished in
                completion ()
            })
    }
}

class DownTransitionAnimation: TransitionManagerAnimation {
    override func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: () -> Void) {

        let fromView = fromViewController.view
        let toView = toViewController.view
        
        container.addSubview(toView)
        
        toView.bottom = fromView.top
        
        toView.spring({ () -> Void in
            toView.bottom = fromView.bottom
        }, completion: { (finshed) -> Void in
            completion ()
        })
    }
}



// MARK: - Transition Manager Animations

enum TransitionManagerAnimations {
    case Fade
    case Down
    
    func transitionAnimation () -> TransitionManagerAnimation {
        switch self {
        case .Fade:
            return FadeTransitionAnimation()
        
        case .Down:
            return DownTransitionAnimation()
        }
    }
}



// MARK: - Base

protocol TransitionManagerDelegate {
    func transition (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: ()->Void)
}

class TransitionManagerAnimation: TransitionManagerDelegate {
    
    func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: () -> Void) {
            
        completion()
    }
}

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    private var presenting = true
    var delegate: TransitionManagerDelegate!
    var interactionController: UIPercentDrivenInteractiveTransition!
    
    let duration: NSTimeInterval = 0.70
    
    
    
    // MARK: Lifecycle
    
    init (transitionAnimation: TransitionManagerAnimations) {
        delegate  = transitionAnimation.transitionAnimation()
    }
    
    
    
    // MARK: UIViewControllerAnimatedTransitioning

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        delegate.transition(
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
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(
        navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return self
    }
    

}
