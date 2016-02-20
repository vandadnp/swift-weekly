//
//  AppDelegate.swift
//  swift-weekly
//
//  Created by Vandad on 2/20/16.
//  Copyright © 2016 Pixolity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func example1(){
    let age: UInt = 22
    
    if case 18...24 = age{
      print("You are between 18 and 24")
    } else {
      print("I have nothing to say!")
    }
    
  }

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    example1()
    
    return true
  }
  
}

