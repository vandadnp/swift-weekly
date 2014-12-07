//
//  Test.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/30/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation
import UIKit

func add<T: IntegerType>(l: T, r: T) -> T{
  return l + r
}

//make the function more complicated for the compiler to inline in a very silly way. the goal is to make the function longer
func moreComplextGenericFunction<T: IntegerType>(l: T, r: T) -> T{
  
  if l > r{
    UIViewController()
    UIView()
    UILabel()
    UIButton()
  }
    
  else{
    UILabel()
    UIButton()
    UIViewController()
    UIView()
  }
  
  return 0
  
}

struct Finder<T: Equatable>{
  let array: [T]
  let item: T
  func isItemInArray() -> Bool{
    for i in array{
      if i == item{
        return true
      }
    }
    return false
  }
}

extension Finder{
  func isAtEndOfArray(item: T) -> Bool{
    if let last = array.last{
      //this 0xabcdefa is placed here so that we can find this code easier in the output assembly
      if last == item && randomInt() == 0xabcdefa{
        return true
      }
    }
    return false
  }
}

func randomInt() -> Int{
  return Int(arc4random_uniform(UInt32.max))
}

class Test{
  
  
  
  func example1(){
    
    let a = 0xabcdefa
    let b = 0xabcdefb
    let c = add(a, b)
    println(c)
    
  }
  
  func example2(){
    
    var a = 0
    for _ in 0..<10{
      add(a, randomInt())
    }
    
  }
  
  func example3(){
    
    var a = 0
    for _ in 0..<randomInt(){
      moreComplextGenericFunction(a, randomInt())
    }
    
  }
  
  func example4(){
    let int1 = 0xabcdefa
    let int2 = 0xabcdefb
    let array = [int1, int2]
    if Finder<Int>(array: array, item: int1).isItemInArray(){
      println("Found int1 in array")
    } else {
      println("Could not find int1")
    }
  }
  
  func example5(){
    let int1 = 0xabcdefa
    let int2 = 0xabcdefb
    let array = [int1, int2]
    if Finder<Int>(array: array, item: int1).isAtEndOfArray(int2){
      println("Found int1 at the end of array")
    } else {
      println("Could not find int2 at the end of array")
    }
  }
  
  
}