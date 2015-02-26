//
//  ViewController.swift
//  swift-weekly
//
//  Created by vandadnp on 18/02/15.
//  Copyright (c) 2015 com.pixolity.ios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    func show(#msg: String, @autoclosure ifTrue: () -> Bool){
        if ifTrue(){
            println(msg)
        }
    }
    
    func example1(){
        let age = 200
        show(msg: "You are too old", ifTrue: age > 140)
    }
    
    @inline(never) func randomInt() -> Int{
        return Int(arc4random_uniform(UInt32.max))
    }
    
    func example2(){
        println(randomInt())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example2()
        
    }
    
}

