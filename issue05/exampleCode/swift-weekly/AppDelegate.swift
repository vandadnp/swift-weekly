//
//  AppDelegate.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/21/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func example1(){
    
    let builder = NameBuilder()
    builder.setFirstName("Vandad")
    builder.setLastName("Nahavandipoor")
    println(builder.toString())
    
  }
  
  func example2(){
    
    Boy().run().run().jump().run().restFor(10).jump().stop()
    
  }
  
  func example3(){
    
    FluentUrlConnection(urlStr: "http://vandadnp.wordpress.com")
      .ofType(.GET)
      .acceptGzip()
      .onConnectionSuccess { (sender: FluentUrlConnection) -> () in
        
        if let data = sender.connectionData{
          println("Got data = \(data)")
        }
        
      }
      .start()
    
    
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    example3()
    
    
    return true
  }
  
}

