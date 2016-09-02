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

  func leftWithOffset (_ offset: CGFloat) -> CGFloat {
    return self.left - offset
  }

  func rightWithOffset (_ offset: CGFloat) -> CGFloat {
    return self.right + offset
  }

  func topWithOffset (_ offset: CGFloat) -> CGFloat {
    return self.top - offset
  }

  func bottomWithOffset (_ offset: CGFloat) -> CGFloat {
    return self.bottom + offset
  }
}

// MARK: Transform Extensions

func degreesToRadians (_ angle: CGFloat) -> CGFloat {
  return (CGFloat (M_PI) * angle) / 180.0
}

extension UIView {

  func setRotationX (_ x: CGFloat) {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -1000.0
    transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)
    self.layer.transform = transform
  }

  func setRotationY (_ y: CGFloat) {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -1000.0
    transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)
    self.layer.transform = transform
  }

  func setRotationZ (_ z: CGFloat) {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -1000.0
    transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)
    self.layer.transform = transform
  }

  func setRotation (
    _ x: CGFloat,
    y: CGFloat,
    z: CGFloat) {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -1000.0
    transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)
    transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)
    transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)
    self.layer.transform = transform
  }

  func setScale (
    _ x: CGFloat,
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
    _ animations: (()->Void),
    completion: ((Bool)->Void)? = nil) {
    spring(UIViewAnimationDuration,
           animations: animations,
           completion: completion)
  }

  func spring (
    _ duration: TimeInterval,
    animations: (()->Void),
    completion: ((Bool)->Void)? = nil) {
    UIView.animate(withDuration: UIViewAnimationDuration,
                   delay: 0,
                   usingSpringWithDamping: UIViewAnimationSpringDamping,
                   initialSpringVelocity: UIViewAnimationSpringVelocity,
                   options: UIViewAnimationOptions.allowAnimatedContent,
                   animations: animations,
                   completion: completion)
  }

  func animate (
    _ duration: TimeInterval,
    animations: (()->Void),
    completion: ((Bool)->Void)? = nil) {
    UIView.animate(withDuration: duration,
                   animations: animations,
                   completion: completion)
  }

  func animate (
    _ animations: (()->Void),
    completion: ((Bool)->Void)? = nil) {
    animate(
      UIViewAnimationDuration,
      animations: animations,
      completion: completion)
  }

  func pop () {
    setScale(1.1, y: 1.1)
    spring(0.2,
           animations: { [unowned self] in
            self.setScale(1, y: 1)
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
    return img!
  }
}

