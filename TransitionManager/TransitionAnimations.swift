//
//  TransitionAnimations.swift
//  TransitionManager
//
//  Created by Cem Olcay on 12/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

enum TransitionManagerAnimations {
    case Fade
    case Left (UINavigationController)
    
    func transitionAnimation () -> TransitionManagerAnimation {
        switch self {
        case .Fade:
            return FadeTransitionAnimation()
            
        case .Left (let nav):
            return LeftTransitionAnimation(navigationController: nav)
            
        default:
            return TransitionManagerAnimation()
        }
    }
}

extension TransitionManager {
    
    convenience init (transition: TransitionManagerAnimations) {
        self.init (transitionAnimation: transition.transitionAnimation())
    }
}



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

class LeftTransitionAnimation: TransitionManagerAnimation {
    
    var navigationController: UINavigationController!
    
    init (navigationController: UINavigationController) {
        super.init()
        
        self.navigationController = navigationController
        self.navigationController.view.addGestureRecognizer(UIPanGestureRecognizer (target: self, action: Selector("didPan:")))
    }
    
    override func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: () -> Void) {
            
        let fromView = fromViewController.view
        let toView = toViewController.view
        
        container.addSubview(toView)
        
        toView.right = fromView.left
        
        toView.spring({ () -> Void in
            toView.right = fromView.right
        },
        completion: { (finshed) -> Void in
            completion ()
        })
    }
    
    func didPan (gesture: UIPanGestureRecognizer) {
        let percent = gesture.translationInView(gesture.view!).x / gesture.view!.bounds.size.width
        
        switch gesture.state {
        case .Began:
            interactionTransitionController = UIPercentDrivenInteractiveTransition()
            navigationController.popViewControllerAnimated(true)
        case .Changed:
            interactionTransitionController!.updateInteractiveTransition(percent)
            
        case .Ended:
            if percent > 0.5 {
                interactionTransitionController!.finishInteractiveTransition()
            } else {
                interactionTransitionController!.cancelInteractiveTransition()
            }
            interactionTransitionController = nil
            
        default:
            return
        }
    }
}


