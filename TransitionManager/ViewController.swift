//
//  ViewController.swift
//  TransitionManager
//
//  Created by Cem Olcay on 11/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var transition: TransitionManager!
    
    @IBOutlet var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transition = TransitionManager (transition: .MaterialCircle(button.center))
        
        title = "First"
        
        var vy: CGFloat = 120
        for i in 0...15 {
            let i = item()
            view.addSubview(i)
            i.y = vy
            vy += i.h + 10
        }
    }
    
    func item () -> UIView {
        let v = UIView (frame: CGRect (x: 10, y: 0, width: view.w - 20, height: 150))
        v.backgroundColor = UIColor.blueColor()
        return v
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushSegue" {
            let destination = segue.destinationViewController as! UIViewController
            destination.transitioningDelegate = transition
        }
    }
}
