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
    
    class Vehicle{
        func id() -> Int{
            return 0xabcdefa
        }
    }
    
    class Car : Vehicle{
        override func id() -> Int {
            return 0xabcdefc
        }
    }
    
    func example2(){
        let v: Vehicle = Car()
        let c = [v][0] as Car
        println(c)
    }
    
    class Bicycle : Vehicle{
        override func id() -> Int {
            return 0xabcdefb
        }
    }
    
    func example3(){
        
        let items = [Bicycle(), Car(), Bicycle()]
        for i in items{
            if let b = i as? Bicycle{
                println(0xabcdefd)
            }
            else if let c = i as? Car{
                println(0xabcdefe)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example2()
    }
    
}

