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
  case fade
  case pull

  var transitionAnimation: TransitionManagerAnimation {
    switch self {
    case .fade:
      return FadeTransitionAnimation()
    case .pull:
      return PullTransitionAnimation()
    }
  }
}

extension TransitionManager {
  convenience init (transition: TransitionManagerAnimations) {
    self.init (transitionAnimation: transition.transitionAnimation)
  }
}

// MARK: - Fade Transition

class FadeTransitionAnimation: TransitionManagerAnimation {

  override func transition(
    _ container: UIView,
    fromViewController: UIViewController,
    toViewController: UIViewController,
    isDismissing: Bool,
    duration: TimeInterval,
    completion: @escaping () -> Void) {
    if isDismissing {
      closeAnimation(
        container,
       fromViewController: fromViewController,
       toViewController: toViewController,
       duration: duration,
       completion: completion)
    } else {
      openAnimation(
        container,
        fromViewController: fromViewController,
        toViewController: toViewController,
        duration: duration,
        completion: completion)
    }
  }

  func openAnimation (
    _ container: UIView,
    fromViewController: UIViewController,
    toViewController: UIViewController,
    duration: TimeInterval,
    completion: @escaping () -> Void) {
    toViewController.view.alpha = 0
    container.addSubview(toViewController.view)
    UIView.animate(
      withDuration: duration,
      animations: {
        toViewController.view.alpha = 1
      }, completion: {
        finished in
        fromViewController.view.alpha = 1
        completion()
      })
  }

  func closeAnimation (
    _ container: UIView,
    fromViewController: UIViewController,
    toViewController: UIViewController,
    duration: TimeInterval,
    completion: @escaping () -> Void) {
    container.addSubview(toViewController.view)
    container.bringSubview(toFront: fromViewController.view)
    UIView.animate(
      withDuration: duration,
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
  fileprivate weak var panningViewController: UIViewController?

  override func transition(
    _ container: UIView,
    fromViewController: UIViewController,
    toViewController: UIViewController,
    isDismissing: Bool,
    duration: TimeInterval,
    completion: @escaping () -> Void) {
    if isDismissing {
      closeAnimation(
        container,
       fromViewController: fromViewController,
       toViewController: toViewController,
       duration: duration,
       completion: completion)
    } else {
      openAnimation(
        container,
        fromViewController: fromViewController,
        toViewController: toViewController,
        duration: duration,
        completion: completion)
    }
  }

  func openAnimation (
    _ container: UIView,
    fromViewController: UIViewController,
    toViewController: UIViewController,
    duration: TimeInterval,
    completion: @escaping () -> Void) {
    container.addSubview(toViewController.view)
    toViewController.view.top = fromViewController.view.bottom
    toViewController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(PullTransitionAnimation.handlePan(_:))))
    panningViewController = toViewController
    UIView.animate(
      withDuration: duration,
      animations: {
        toViewController.view.top = 0
      }, completion: {
        finished in
        completion()
      })
  }

  func closeAnimation (
    _ container: UIView,
    fromViewController: UIViewController,
    toViewController: UIViewController,
    duration: TimeInterval,
    completion: @escaping () -> Void) {
    container.addSubview(toViewController.view)
    container.bringSubview(toFront: fromViewController.view)
    UIView.animate(
      withDuration: duration,
      animations: {
        fromViewController.view.top = toViewController.view.bottom
      }, completion: {
        finished in
        completion()
      })
  }

  func handlePan(_ pan: UIPanGestureRecognizer) {
    let percent = pan.translation(in: pan.view!).y / pan.view!.bounds.size.height
    switch pan.state {
    case .began:
      interactionTransitionController = UIPercentDrivenInteractiveTransition()
      panningViewController?.dismiss(animated: true, completion: {
        self.interactionTransitionController?.finish()
      })
    case .changed:
      interactionTransitionController!.update(percent)
    case .ended:
      if percent > 0.5 {
        interactionTransitionController!.finish()
        panningViewController = nil
      } else {
        interactionTransitionController!.cancel()
      }
      interactionTransitionController = nil
    default:
      return
    }
  }
}
