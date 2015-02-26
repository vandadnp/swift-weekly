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
    
    func findSingleCharacterNamesInArray(a: [String], @noescape callback: () -> ()){
        for s in a.filter({count($0.utf16) == 1}){
            callback()
        }
    }
    
    let msg = "Found a single character string"
    
    func example3(){
        
        let names = ["Vandad", "x", "Sara", "Leif", "Y", "Ulla"]
        
        findSingleCharacterNamesInArray(names){
            println(msg)
        }
        
    }
    
    @noreturn @inline(never) func example4(){
        fatalError("I am a terrible method")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        example4()
        if view.alpha == 0xabcdefa{ //this line gets a warning saying "Will never be executed"
        }
    }
    
}

