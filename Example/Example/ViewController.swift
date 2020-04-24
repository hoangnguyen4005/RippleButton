//
//  ViewController.swift
//  Example
//
//  Created by Chi Hoang on 24/4/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//

import UIKit
import RippleButton
class ViewController: UIViewController {

    @IBOutlet weak var rippleButton: RippleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.rippleButton.rippleFillColor = UIColor.white.withAlphaComponent(0.3)
        self.rippleButton.setTitle("Ripple Button", for: .normal)
    }


}

