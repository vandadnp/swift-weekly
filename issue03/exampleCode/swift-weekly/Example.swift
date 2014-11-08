//
//  Example.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/8/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation

enum CarType: Int{
  case CarTypeSaloon = 0xabcdefa
  case CarTypeHatchback
}

struct Example{
  
func example1(){
  
  let saloon = CarType.CarTypeSaloon
  println(saloon.rawValue)
  
  let hatchback = CarType.CarTypeHatchback
  println(hatchback.rawValue)
  
}
  
}