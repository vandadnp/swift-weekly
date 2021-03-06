//
//  AppDelegate.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/2/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func example1(){
    let a = 0xabcdefa
    println(a)
    let b = 0xabcdefb
    println(b)
  }
  
  func example2(){
    let a = 0xabcdefa
    println(0xabcdefa)
  }
  
  func example3(){
    let a = 0xabcdefa
    var b = 0xabcdefb
    let c = a + b
  }
  
  func example4(){
    let intConstant = 0xabcdefa
    let intVariable = 0xabcdefb
    
    let boolConstant = true
    var boolVariable = false
    
    let doubleConstant = 1.23
    let doubleVariable = 2.34
    
    let floatConstant:Float = 1.23
    let floatVariable: Float = 2.34
  }
  
  func example5(){
    //    let person = Person(age: 30)
  }
  
  func example6(){
    var person = Person()
    person.age = 0xabcdefa
    person.sex = 0xabcdefb
    person.numberOfChildren = 0xabcdefc
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    return true
  }
  
}

