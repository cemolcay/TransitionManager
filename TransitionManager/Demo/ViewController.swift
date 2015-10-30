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

    init(title: String, action: () -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        self.action = action
        setTitle(title, forState: .Normal)
        setTitleColor(UIColor(red: 230.0/255.0, green: 172.0/255.0, blue: 39.0/255.0, alpha: 1), forState: .Normal)
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        layer.borderWidth = 3
        layer.borderColor = UIColor(red: 191.0/255.0, green: 77.0/255.0, blue: 40.0/255.0, alpha: 1).CGColor
        layer.cornerRadius = 25
        addTarget(self, action: "actionHandler:", forControlEvents: .TouchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func actionHandler(sender: AnyObject) {
        action()
    }
}

class ViewController: UIViewController {
    var transitionManager: TransitionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup transitioning
        transitionManager = TransitionManager(transition: .Pull)
        transitioningDelegate = transitionManager
        // setup view
        let button = DemoButton(title: "Next", action: {
            self.performSegueWithIdentifier("modal", sender: nil)
        })
        button.center.x = view.center.x
        button.y = 50
        view.addSubview(button)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.transitioningDelegate = transitionManager
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
