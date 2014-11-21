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
  
  private lazy var httpHeaders: [String : String] = {
    return [String : String]()
    }()
  
  private var connectionSuccessHandler: Block?
  private var connectionFailureHanlder: Block?
  
  private var acceptsGzip = false
  
  init(url: NSURL){
    self.url = url
  }
  
  convenience init(urlStr: String){
    self.init(url: NSURL(string: urlStr)!)
  }
  
  func acceptGzip() -> Self{
    acceptsGzip = true
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
    httpHeaders[forKey] = value
    return self
  }
  
  func onConnectionSuccess(handler: Block) -> Self{
    connectionSuccessHandler = handler
    return self
  }
  
  func onConnectionFailure(handler: Block) -> Self{
    connectionFailureHanlder = handler
    return self
  }
  
  func ofType(type: FluentUrlConnectionType) -> Self{
    self.type = type
    return self
  }
  
//this attaches "gzip" to the end of the "Accept-Encoding" key of the httpHeaders if gzip encoding is enabled
private func handleGzipFlag(){
  if acceptsGzip{
    var acceptEncodingKey = "Accept-Encoding"
    var acceptEncodingValue = "gzip"
    
    for (key, value) in httpHeaders{
      if key == acceptEncodingKey{
        acceptEncodingValue += ", " + value
      }
    }
    httpHeaders[acceptEncodingKey] = acceptEncodingValue
  }
}



func start() -> Self{
  
  handleGzipFlag()
  
  let request = NSMutableURLRequest(URL: url)
  request.HTTPBody = httpBody
  request.HTTPMethod = type.rawValue
  request.allHTTPHeaderFields = httpHeaders
  
  NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
    
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
      self.connectionData = data
      self.connectionError = error
      self.connectionResponse = response
      
      if (error != nil){
        //an error happened
        if let errorHandler = self.connectionFailureHanlder{
          errorHandler(sender: self)
        }
      } else {
        
        //we succeeded, let the listener know
        if let successHandler = self.connectionSuccessHandler{
          successHandler(sender: self)
        }
        
        //now see if we have a real http url response so that we can get the http code out of it
        if let httpResponse = response as? NSHTTPURLResponse{
          
          var httpCodeIsHandled = false
          let statusCode = httpResponse.statusCode
          let handler = self.httpCodeHandlers[statusCode]
          
          if let handler = handler{
            httpCodeIsHandled = true
            handler(sender: self)
          }
          
          if !httpCodeIsHandled{
            if let unhandledCodeBlock = self.unhandledHttpCodeHandler{
              unhandledCodeBlock(sender: self)
            }
          }
          
        }
        
      }
      
      
    })
    
  }
  
  return self
}
  
}
