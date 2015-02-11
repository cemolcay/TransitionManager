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
            
            toView.alpha = 0
            
            container.addSubview(toView)
            container.addSubview(fromView)
            
            UIView.animateWithDuration(duration,
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.8,
                options: nil,
                animations: {
                    toView.alpha = 1
                }, completion: { finished in
                    completion ()
                }
            )
    }
}

class DownTransitionAnimation: TransitionManagerAnimation {
    override func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: () -> Void) {
        
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

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: Properties
    
    private var presenting = true
    var delegate: TransitionManagerDelegate!
    
    
    
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
        return 0.75
    }
}
