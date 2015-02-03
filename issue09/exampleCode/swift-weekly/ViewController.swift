//
//  ViewController.swift
//  swift-weekly
//
//  Created by vandadnp on 11/01/15.
//  Copyright (c) 2014 com.pixolity.ios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let array = ["Vandad",0xabcdefa, "Julian",0xabcdefb, "Leif", 0xabcdefc]
        as [AnyObject] //done to ensure no implicit NSArray conversion is happening
    
    func randomIndexInArray(a: [AnyObject]) -> Int{
        return Int(arc4random_uniform(UInt32(a.count)))
    }
    
    func example1(){
        
        for i in 0..<array.count{
            let index = randomIndexInArray(array)
            let obj: AnyObject = array[index]
            println(obj)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example1()
        
    }
    
}

