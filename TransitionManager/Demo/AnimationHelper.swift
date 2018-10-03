//
//  AnimationHelper.swift
//  TransitionManager
//
//  Created by Cem Olcay on 12/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

// MARK: Frame Extensions

extension UIView {

  var x: CGFloat {
    get {
      return self.frame.origin.x
    } set (value) {
      self.frame = CGRect (x: value, y: self.y, width: self.w, height: self.h)
    }
  }

  var y: CGFloat {
    get {
      return self.frame.origin.y
    } set (value) {
      self.frame = CGRect (x: self.x, y: value, width: self.w, height: self.h)
    }
  }

  var w: CGFloat {
    get {
      return self.frame.size.width
    } set (value) {
      self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.h)
    }
  }

  var h: CGFloat {
    get {
      return self.frame.size.height
    } set (value) {
      self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: value)
    }
  }

  var left: CGFloat {
    get {
      return self.x
    } set (value) {
      self.x = value
    }
  }

  var right: CGFloat {
    get {
      return self.x + self.w
    } set (value) {
      self.x = value - self.w
    }
  }

  var top: CGFloat {
    get {
      return self.y
    } set (value) {
      self.y = value
    }
  }

  var bottom: CGFloat {
    get {
      return self.y + self.h
    } set (value) {
      self.y = value - self.h
    }
  }

  var position: CGPoint {
    get {
      return self.frame.origin
    } set (value) {
      self.frame = CGRect (origin: value, size: self.frame.size)
    }
  }

  var size: CGSize {
    get {
      return self.frame.size
    } set (value) {
      self.frame = CGRect (origin: self.frame.origin, size: value)
    }
  }

  func leftWithOffset (offset: CGFloat) -> CGFloat {
    return self.left - offset
  }

  func rightWithOffset (offset: CGFloat) -> CGFloat {
    return self.right + offset
  }

  func topWithOffset (offset: CGFloat) -> CGFloat {
    return self.top - offset
  }

  func bottomWithOffset (offset: CGFloat) -> CGFloat {
    return self.bottom + offset
  }
}

// MARK: Transform Extensions

func degreesToRadians (angle: CGFloat) -> CGFloat {
  return (.pi * angle) / 180.0
}

extension UIView {

  func setRotationX (x: CGFloat) {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -1000.0
    transform = CATransform3DRotate(transform, degreesToRadians(angle: x), 1.0, 0.0, 0.0)
    self.layer.transform = transform
  }

  func setRotationY (y: CGFloat) {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -1000.0
    transform = CATransform3DRotate(transform, degreesToRadians(angle: y), 0.0, 1.0, 0.0)
    self.layer.transform = transform
  }

  func setRotationZ (z: CGFloat) {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -1000.0
    transform = CATransform3DRotate(transform, degreesToRadians(angle: z), 0.0, 0.0, 1.0)
    self.layer.transform = transform
  }

  func setRotation (
    x: CGFloat,
    y: CGFloat,
    z: CGFloat) {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -1000.0
    transform = CATransform3DRotate(transform, degreesToRadians(angle: x), 1.0, 0.0, 0.0)
    transform = CATransform3DRotate(transform, degreesToRadians(angle: y), 0.0, 1.0, 0.0)
    transform = CATransform3DRotate(transform, degreesToRadians(angle: z), 0.0, 0.0, 1.0)
    self.layer.transform = transform
  }

  func setScale (
    x: CGFloat,
    y: CGFloat) {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -1000.0
    transform = CATransform3DScale(transform, x, y, 1)
    self.layer.transform = transform
  }
}

// MARK: Animation Extensions

let UIViewAnimationDuration: TimeInterval = 1
let UIViewAnimationSpringDamping: CGFloat = 0.5
let UIViewAnimationSpringVelocity: CGFloat = 0.5

extension UIView {

  func spring (
    duration: TimeInterval = UIViewAnimationDuration,
    animations: @escaping (() -> Void),
    completion: ((Bool) -> Void)? = nil) {
    UIView.animate(
      withDuration: duration,
      delay: 0,
      usingSpringWithDamping: UIViewAnimationSpringDamping,
      initialSpringVelocity: UIViewAnimationSpringVelocity,
      options: [UIView.AnimationOptions.allowAnimatedContent],
      animations: animations,
      completion: completion)
  }

  func animate (
    duration: TimeInterval,
    animations: @escaping (() -> Void),
    completion: ((Bool) -> Void)? = nil) {
    UIView.animate(
      withDuration: duration,
      animations: animations,
      completion: completion)
  }

  func animate (
    animations: @escaping (() -> Void),
    completion: ((Bool) -> Void)? = nil) {
    animate(
      duration: UIViewAnimationDuration,
      animations: animations,
      completion: completion)
  }

  func pop () {
    setScale(x: 1.1, y: 1.1)
    spring(
      duration: 0.2,
      animations: { [unowned self] in
        self.setScale(x: 1, y: 1)
      })
  }
}

// MARK: Render Extensions

extension UIView {
  func toImage () -> UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
    drawHierarchy(in: bounds, afterScreenUpdates: false)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img ?? UIImage()
  }
}

