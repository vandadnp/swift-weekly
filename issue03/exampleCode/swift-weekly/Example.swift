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

enum MaleNames: String{
  case Vandad = "Vandad"
  case Kim = "Kim"
}

enum FemaleNames: String{
  case Sara = "Sara"
  case Kim = "Kim"
}



struct Example{
  
  func example1(){
    
    let saloon = CarType.CarTypeSaloon
    println(saloon.rawValue)
    
    let hatchback = CarType.CarTypeHatchback
    println(hatchback.rawValue)
    
  }
  
  func example2(){
    
    println(MaleNames.Vandad)
    println(MaleNames.Kim)
    println(FemaleNames.Sara)
    println(FemaleNames.Kim)
    
  }
  
func carType() -> CarType{
  return .CarTypeHatchback
}

func example3(){
  
  let type = carType()
  
  switch type{
  case .CarTypeSaloon:
    println(0xaaaaaaaa)
  case .CarTypeHatchback:
    println(0xbbbbbbbb)
  default:
    println(0xcccccccc)
  }
  
}
  
}