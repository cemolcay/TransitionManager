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

class TransitionManager: NSObject,
UIViewControllerAnimatedTransitioning,
UIViewControllerTransitioningDelegate,
UINavigationControllerDelegate {
    
    // MARK: Properties
    
    var interactionController: UIPercentDrivenInteractiveTransition?

    var delegate: TransitionManagerDelegate!
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
        return interactionController
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
    
    func navigationController(
        navigationController: UINavigationController,
        interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    

}

class InteractionTransitionNavigationController: UINavigationController {
    
    
    // MARK: Properties
    
    var transitionManager: TransitionManager?
    
    override var delegate: UINavigationControllerDelegate? {
        didSet {
            if delegate is TransitionManager {
                transitionManager = delegate as? TransitionManager
            }
        }
    }
    
    
    
    // MARK: Lifecycle
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInteractionController()
    }
    
    
    
    // MARK: Interaction Transitioning
    
    func setupInteractionController () {
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: "handlePan:")
        pan.edges = .Left
        self.view.addGestureRecognizer(pan);
    }
    
    func handlePan(gesture: UIScreenEdgePanGestureRecognizer) {
        let percent = gesture.translationInView(gesture.view!).x / gesture.view!.bounds.size.width
        
        if gesture.state == .Began {
            transitionManager?.interactionController = UIPercentDrivenInteractiveTransition()
            popViewControllerAnimated(true)
        } else if gesture.state == .Changed {
            transitionManager?.interactionController!.updateInteractiveTransition(percent)
        } else if gesture.state == .Ended {
            if percent > 0.5 {
                transitionManager?.interactionController!.finishInteractiveTransition()
            } else {
                transitionManager?.interactionController!.cancelInteractiveTransition()
            }
            transitionManager?.interactionController = nil
        }
    }
}
