//
//  TransitionManager.swift
//  Transition
//
//  Created by Cem Olcay on 12/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

public protocol TransitionManagerDelegate {

  /// Transition animation method implementation
  func transition(
    _ container: UIView,
    fromViewController: UIViewController,
    toViewController: UIViewController,
    isDismissing: Bool,
    duration: TimeInterval,
    completion: @escaping () -> Void)

  /// Interactive transitions,
  /// update percent in gesture handler
  var interactionTransitionController: UIPercentDrivenInteractiveTransition? { get set }
}

open class TransitionManagerAnimation: NSObject, TransitionManagerDelegate {

  // MARK: TransitionManagerDelegate
  open func transition(
    _ container: UIView,
    fromViewController: UIViewController,
    toViewController: UIViewController,
    isDismissing: Bool,
    duration: TimeInterval,
    completion: @escaping () -> Void) {
    completion()
  }

  fileprivate var _interactionTransitionController: UIPercentDrivenInteractiveTransition? = nil
  open var interactionTransitionController: UIPercentDrivenInteractiveTransition? {
    get {
      return _interactionTransitionController
    } set {
      _interactionTransitionController = newValue
    }
  }
}

open class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
  fileprivate var transitionAnimation: TransitionManagerAnimation!
  fileprivate var isDismissing: Bool = false
  fileprivate var duration: TimeInterval = 0.30

  // MARK: Lifecycle
  public init (transitionAnimation: TransitionManagerAnimation) {
    self.transitionAnimation = transitionAnimation
  }

  // MARK: UIViewControllerAnimatedTransitioning
  open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
    transitionAnimation.transition(
      container,
      fromViewController: fromViewController!,
      toViewController: toViewController!,
      isDismissing: isDismissing,
      duration: transitionDuration(using: transitionContext),
      completion: {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }

  open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  // MARK: UIViewControllerTransitioningDelegate
  open func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isDismissing = false
    return self
  }

  open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    isDismissing = true
    return self
  }

  open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    isDismissing = false
    return transitionAnimation.interactionTransitionController
  }

  open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    isDismissing = true
    return transitionAnimation.interactionTransitionController
  }

  // MARK: UINavigationControllerDelegate
  open func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationControllerOperation,
    from fromVC: UIViewController,
    to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if operation == .pop {
      isDismissing = true
    } else {
      isDismissing = false
    }
    return self
  }

  open func navigationController(
    _ navigationController: UINavigationController,
    interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return transitionAnimation.interactionTransitionController
  }
}
