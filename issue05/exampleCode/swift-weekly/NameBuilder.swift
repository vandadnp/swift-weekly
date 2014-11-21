//
//  UrlBuilder.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/21/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation

class NameBuilder{
  
  private var firstName = ""
  private var lastName = ""
  
  func setFirstName(f: String){
    firstName = f
  }
  
  func setLastName(l: String){
    lastName = l
  }
  
  func toString() -> String{
    return "\(firstName) \(lastName)"
  }
  
}