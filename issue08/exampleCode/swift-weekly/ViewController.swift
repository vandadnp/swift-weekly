//
//  ViewController.swift
//  swift-weekly
//
//  Created by vandadnp on 11/01/15.
//  Copyright (c) 2014 com.pixolity.ios. All rights reserved.
//

import UIKit

struct Person{
    var name: String
}

struct Car{
    var manufacturingYear: UInt
}

class ViewController: UIViewController {
    
    func example1(){
        let items = [
            0xabcdefa,
            "Foo",
            0xabcdefb,
            "Bar"
        ]
        
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

