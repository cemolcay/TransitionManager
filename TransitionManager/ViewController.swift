//
//  ViewController.swift
//  TransitionManager
//
//  Created by Cem Olcay on 11/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let transitionManager = TransitionManager (transitionAnimation: .Down)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = transitionManager
    }
}