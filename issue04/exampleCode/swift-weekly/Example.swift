//
//  Example.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/15/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation

class Example{
  
  func example1(){
    
    let int1 = 0xabcdefa
    let int2 = 0xabcdefb
    let int3 = int1 + int2
    println(int3)
    
    let int4 = 0xabcdefa + 0xabcdefb
    println(int4)
    
  }
  
  func example2(){
    
    var int1 = 0xabcdefa
    var int2 = 0xabcdefb
    var int3 = int1 + int2
    println(int3)
    
    var int4 = 0xabcdefa + 0xabcdefb
    println(int4)
    
  }
  
  func randomInt() -> Int{
    return Int(arc4random_uniform(UInt32.max))
  }
  
  func example3(){
    
    var int1 = randomInt()
    var int2 = randomInt()
    var int3 = int1 + int2
    
  }
  
  func example4(){
    
    let int1 = randomInt()
    let int2 = randomInt()
    let int3 = int1 - int2
    println(int3)
    
  }
  
  func example5(){
    
    let int1 = random()
    let int2 = random()
    let int3 = int1 > int2 ? 0xabcdefa : 0xabcdefb
    println(int3)
    
  }
  
  func example6(){
    let bool = Bool(random()) ? 0xabcdefa : 0xabcdefb
    println(bool)
  }
  
}






