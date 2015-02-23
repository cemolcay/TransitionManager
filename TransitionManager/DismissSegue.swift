//
//  DismissSegue.swift
//  TransitionManager
//
//  Created by Cem Olcay on 17/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

@objc(DismissSegue)
class DismissSegue: UIStoryboardSegue {
   
    override func perform() {
        let source = self.sourceViewController as! UIViewController
        source.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
