//
//  TransitionManagerNavigationController.swift
//  TransitionManager
//
//  Created by Cem Olcay on 11/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class TransitionManagerNavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    let transitionManager = TransitionManager (transitionAnimation: .Fade)
    var interactionController: UIPercentDrivenInteractiveTransition!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        self.delegate = self
        setupInteractionController()
    }

    
    func setupInteractionController () {
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: "handlePan:")
        pan.edges = .Left
        self.view.addGestureRecognizer(pan);
    }
    
    func handlePan(gesture: UIScreenEdgePanGestureRecognizer) {
        let percent = gesture.translationInView(gesture.view!).x / gesture.view!.bounds.size.width
        
        if gesture.state == .Began {
            interactionController = UIPercentDrivenInteractiveTransition()
            dismissViewControllerAnimated(true, completion: nil)
        } else if gesture.state == .Changed {
            interactionController.updateInteractiveTransition(percent)
        } else if gesture.state == .Ended {
            if percent > 0.5 {
                interactionController.finishInteractiveTransition()
            } else {
                interactionController.cancelInteractiveTransition()
            }
            interactionController = nil
        }
    }
    

    
    // MARK: UIViewControllerTransitioningDelegate

    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionManager
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionManager
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
            return transitionManager
    }

}