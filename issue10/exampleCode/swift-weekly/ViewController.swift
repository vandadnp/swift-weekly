//
//  ViewController.swift
//  swift-weekly
//
//  Created by vandadnp on 18/02/15.
//  Copyright (c) 2015 com.pixolity.ios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    func example1(){
        
        let p = CGPoint(x: 0xaaaaaaaa, y: 0xbbbbbbbb)
        let f = view.frame
        let fs = f.size
        
        switch (p.x, p.y){
        case (0xabcdefc, 0):
            println(0xabcdefc)
        case (fs.width, 0xabcdefe):
            println(0xabcdefe)
        case (0xabcdeff, fs.height):
            println(0xabcdeff)
        default:
            println(0xffffffff)
        }
        
    }
    
    func randomInt() -> Int{
        return Int(arc4random_uniform(UInt32.max))
    }
    
    func example2(){
        
        switch randomInt(){
        case 0...100:
            println(0xabcdefa)
        case 101...200:
            println(0xabcdefb)
        default:
            println(0xabcdefc)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        example2()
    }
    
}

