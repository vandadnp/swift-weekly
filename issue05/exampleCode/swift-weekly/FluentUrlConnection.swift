//
//  FluentUrlConnection.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/21/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

import Foundation

typealias Block = (sender: FluentUrlConnection) -> ()

enum FluentUrlConnectionType : String{
  case POST = "POST"
  case GET = "GET"
  case PUT = "PUT"
  case DELETE = "DELETE"
}

class FluentUrlConnection{
  
  private var url: NSURL
  private var type = FluentUrlConnectionType.GET
  
  var connectionData: NSData?
  var connectionError: NSError?
  var connectionResponse: NSURLResponse?
  
  private var unhandledHttpCodeHandler : Block?
  
  private lazy var httpCodeHandlers: [Int : Block] = {
    return [Int : Block]()
  }()
  
  private var httpBody: NSData?
  
  init(url: NSURL){
    self.url = url
  }
  
  convenience init(urlStr: String){
    self.init(url: NSURL(string: urlStr)!)
  }
  
  func acceptGzip() -> Self{
    return self
  }
  
  func onHttpCode(code: Int, handler: Block) -> Self{
    httpCodeHandlers[code] = handler
    return self
  }
  
  func onUnhandledHttpCode(handler: Block) -> Self{
    unhandledHttpCodeHandler = handler
    return self
  }
  
func setHttpBody(body: NSData) -> Self{
  httpBody = body
  return self
}
  
  func setHttpBody(body: String) -> Self{
    return setHttpBody(body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
  }
  
  func setHttpHeader(#value: String, forKey: String) -> Self{
    return self
  }
  
  func start() -> Self{
    return self
  }
  
  func onConnectionSuccess(handler: Block) -> Self{
    return self
  }
  
  func onConnectionFailure(handler: Block) -> Self{
    return self
  }
  
  func ofType(type: FluentUrlConnectionType) -> Self{
    self.type = type
    return self
  }
  
}
