//
//  TransitionAnimations.swift
//  TransitionManager
//
//  Created by Cem Olcay on 12/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit


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

class MaterialCircleTransitionAnimation: TransitionManagerAnimation {
    
    var navigationController: UINavigationController!
    
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
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
            
            toView.bottom = fromView.top
            
            toView.spring({ () -> Void in
                toView.bottom = fromView.bottom
                },
                completion: { (finshed) -> Void in
                    completion ()
            })
    }
    
    override func interactionTransition(interactionController: UIPercentDrivenInteractiveTransition?) -> UIPercentDrivenInteractiveTransition? {
        return interactionController
    }
}


