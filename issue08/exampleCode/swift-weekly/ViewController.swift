//
//  ViewController.swift
//  swift-weekly
//
//  Created by vandadnp on 11/01/15.
//  Copyright (c) 2014 com.pixolity.ios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let items = [
        0xabcdefa,
        "Foo",
        0xabcdefb,
        "Bar"
    ]
    
    func example1(){
        
        for v in items{
            
            if v is Int{
                println(0xabcdefc)
            }
            else if v is String{
                println(0xabcdefd)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example1()
    }

}

