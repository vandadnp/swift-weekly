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
  .setHttpBody("hello world")
  .setHttpHeader(value: "Accept", forKey: "application/json")
  .onHttpCode(200, handler: { (sender: FluentUrlConnection) -> () in
    
  })
  .onHttpCode(401, handler: { (sender: FluentUrlConnection) -> () in
    
  })
  .onUnhandledHttpCode { (sender: FluentUrlConnection) -> () in
    
  }
  .onConnectionSuccess { (sender: FluentUrlConnection) -> () in
    
  }
  .onConnectionFailure { (sender: FluentUrlConnection) -> () in
    
  }
  .start()
    
    
  }

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    example2()
    
    
    return true
  }

}

