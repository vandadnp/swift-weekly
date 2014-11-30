//
//  Test.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/30/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation

func add<T: IntegerType>(l: T, r: T) -> T{
  return l + r
}

class Test{
  
  func randomInt() -> Int{
    return Int(arc4random_uniform(UInt32.max))
  }
  
  func example1(){
    
    let a = 0xabcdefa
    let b = 0xabcdefb
    let c = add(a, b)
    println(c)
    
  }
  
}