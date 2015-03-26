//
//  ViewController.swift
//  swift-weekly
//
//  Created by vandadnp on 18/02/15.
//  Copyright (c) 2015 com.pixolity.ios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let objc = ObjcClass()
        println("Result of add is \(objc.add(200, b: 300))")
        
    }
    
}

