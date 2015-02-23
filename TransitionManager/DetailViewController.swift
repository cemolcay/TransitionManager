//
//  DetailViewController.swift
//  TransitionManager
//
//  Created by Cem Olcay on 11/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        
        title = "Detail"
        
        var vy: CGFloat = 120
        for i in 0...15 {
            let i = item()
            view.addSubview(i)
            i.y = vy
            vy += i.h + 10
        }
    }

    func item () -> UIView {
        let v = UIView (frame: CGRect (x: 10, y: 0, width: view.w - 20, height: 60))
        v.backgroundColor = UIColor.redColor()
        return v
    }
}
