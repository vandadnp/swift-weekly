//
//  Person.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/2/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation

struct Person{
  var age: Int = 0
  var sex: Int = 0
  var numberOfChildren: Int = 0
  
  mutating func setAge(paramAge: Int){
    age = paramAge
  }
  
  mutating func setSex(paramSex: Int){
    sex = paramSex
  }
  
  mutating func setNumberOfChildren(paramNumberOfChildren: Int){
    numberOfChildren = paramNumberOfChildren
  }
  
}