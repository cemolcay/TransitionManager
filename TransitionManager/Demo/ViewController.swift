//
//  ViewController.swift
//  TransitionManager
//
//  Created by Cem Olcay on 11/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class DemoButton: UIButton {
  private var action: (() -> Void)!

  init(title: String, action: @escaping () -> Void) {
    super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    self.action = action
    setTitle(title, for: .normal)
    setTitleColor(UIColor(red: 230.0/255.0, green: 172.0/255.0, blue: 39.0/255.0, alpha: 1), for: .normal)
    titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
    layer.borderWidth = 3
    layer.borderColor = UIColor(red: 191.0/255.0, green: 77.0/255.0, blue: 40.0/255.0, alpha: 1).cgColor
    layer.cornerRadius = 25
    addTarget(self, action: #selector(actionHandler(sender:)), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  @objc func actionHandler(sender: AnyObject) {
    action()
  }
}

class ModalViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let button = DemoButton(title: "Back", action: {
      self.dismiss(animated: true, completion: nil)
    })
    button.center.x = view.center.x
    button.y = 50
    view.addSubview(button)
  }
}

class ViewController: UIViewController {
  let transitionManager = TransitionManager(transition: .pull)

  override func viewDidLoad() {
    super.viewDidLoad()
    // setup transitioning
    transitioningDelegate = transitionManager

    // setup view
    let button = DemoButton(title: "Next", action: {
      self.performSegue(withIdentifier: "modal", sender: nil)
    })
    button.center.x = view.center.x
    button.y = 50
    view.addSubview(button)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segue.destination.transitioningDelegate = transitionManager
  }
}
