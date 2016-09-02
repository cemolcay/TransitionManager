//
//  ModalViewController.swift
//  TransitionManager
//
//  Created by Cem Olcay on 11/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

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
