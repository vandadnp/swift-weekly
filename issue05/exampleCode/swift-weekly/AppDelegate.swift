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
      .onConnectionFailure { (sender: FluentUrlConnection) -> () in
        println("Failed. \(sender.connectionError)")
      }
      .start()
    
    //NSURLConnection example
    let url = NSURL(string: "http://vandadnp.wordpress.com")!
    let request = NSMutableURLRequest(URL: url)
    request.allHTTPHeaderFields = ["Accept-Encoding" : "gzip"]
    let queue = NSOperationQueue()
    
    NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
      
      if error != nil{
        println("Error = \(error)")
      } else {
        
        // success
        
        if let httpResponse = response as? NSHTTPURLResponse{
          
          if (httpResponse == 200){
            
          } else {
            
          }
          
          if data != nil{
            // do something
          }
          
        }
        
      }
      
    }
    
  }
  
  func example4(){
    
    FluentSerialQueue().onBackround { () -> () in
      println("Background 1, thread = \(NSThread.currentThread())")
      }.onMainThread { () -> () in
        println("Main 1, thread = \(NSThread.currentThread())")
      }.onBackround { () -> () in
        println("Background 2, thread = \(NSThread.currentThread())")
      }.onMainThread { () -> () in
        println("Main 2, thread = \(NSThread.currentThread())")
      }.start()
    
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    example4()
    
    return true
  }
  
}

