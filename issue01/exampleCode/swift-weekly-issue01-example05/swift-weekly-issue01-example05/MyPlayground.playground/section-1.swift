//
//  You are free to submit your changes/additions/fixes through
//  GitHub's Pull-Request system.
//
//  I do __not__ take any responsibility as to how and why or when you
//  use these example codes.
//
//  Please feel free to share Swift Weekly with anybody who you might
//  think may enjoy them.
//
//  Also feel free to contact me personally if you have any questions
//  or ideas for the next Swift Weekly

import Foundation

let array:NSArray = ["Name", "Last name", "Age", "Sex"]
array.enumerateObjectsUsingBlock {
  (obj: AnyObject!, index: Int,
  stop: UnsafeMutablePointer<ObjCBool>) -> Void in
  if let myString = obj as? String{
    if myString == "Last name"{
      println("Found the last name")
      stop.memory = true
    }
  }
}

