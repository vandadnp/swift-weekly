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
    
    let dict = [
        0xabcdefa : 0xabcdefa,
        0xabcdefb : 0xabcdefb,
        0xabcdefc : 0xabcdefc
    ]
    
    func randomIndexInDictionary(a: [Int : Int]) -> Int{
        return Int(arc4random_uniform(UInt32(a.count)))
    }
    
    func example1(){
        
        for i in 0..<array.count{
            let index = randomIndexInArray(array)
            let obj: AnyObject = array[index]
            println(obj)
        }
        
    }
    
    func example2(){
        
        let value2 = dict[randomIndexInDictionary(dict)]!
        println(value2)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example2()
        
    }
    
}

