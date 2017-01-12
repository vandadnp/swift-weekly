Swift Weekly - Issue 05 - The Builder Pattern and Fluent Interface
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
A few weeks ago I started checking out some Wikipedia articles about various s/e design patterns and came across the [Builder pattern](http://en.wikipedia.org/wiki/Builder_pattern) which is a Creational GoF pattern. Then as you know, I cannot just read one article in one sitting. I have to click every link that the article leads to, so I stumbled upon the article about [Fluent Interfaces](http://en.wikipedia.org/wiki/Fluent_interface) and I could then see the possibilities.

__Note__: Fluent Interfaces have __nothing__ to do with IB or a visual interface that is displayed on the screen at all. Fluent interfaces are the way that we can write our software to ensure they are... well... fluent. Read on to understand how this works.

I don't think fluent interfaces are the same as the builder pattern. I don't really think fluent interface is actually a pattern at all. I believe that fluent interfaces are a concept, and a kick ass one at that. I think mixing fluent interfaces and the builder pattern will allow us to build Swift classes that are amazingly simple to use, instead of the classic OOP designs that we see on pretty much every Apple class these days. I wish Apple could read this article and (ehem), just update their iOS SDK classes for instance to use fluent interfaces and the builder pattern.

If you want to write your Swift apps in the most kick ass way, continue reading. I think this article will help you a lot not only in learning more about Swift, but also writing some really crazy code that will make your life and those around you much easier.

An Example of the Builder Pattern
===
Let's see an example of the Builder pattern:

```swift
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
```

This is easy to understand. There is a class with first name and last name and you can use it like so:

```swift
let builder = NameBuilder()
builder.setFirstName("Vandad")
builder.setLastName("Nahavandipoor")
println(builder.toString())
```

okay we all can understand how the Builder pattern works in Swift. Let's move on.

An Example of Fluent Interfaces in Swift
===
Pay attention to this `Boy` class:

```swift
class Boy{
  
  func jump() -> Self{
    println("Jumping...")
    return self
  }
  
  func run() -> Self{
    println("Running...")
    return self
  }
  
  func restFor(seconds: Int) -> Self{
    println("Resting for \(seconds) seconds")
    return self
  }
  
  func stop() -> Self{
    println("Stopping")
    return self
  }
  
}
```

"what the hell kind of sourcery is this?" you asked... well, pay attention to how every method returns `self`. This allows us to chain our method calls. This is the foundation of fluent interfaces. Now how can we use this awesome code? With an even more awesome code:

```swift
Boy().run().run().jump().run().restFor(10).jump().stop()
```

And the output will be like this:

```
Running...
Running...
Jumping...
Running...
Resting for 10 seconds
Jumping...
Stopping
```
freaking amazing, right? Did the coin drop? awesome. Let's move on. I want let you know that if you have a method in your Swift code that returns `Void`, please change it so that it returns `Self`. No harm done if you don't use the return value, at least your code will be fluent.

Creating a Fluent Url Connection Class to Replace `NSURLConnection`
===
I loved `NSURLConnection` before I got into fluent interfaces. I think this class has so much potential and Apple wasted it by returning `void` from many of the methods. This is just unacceptable. I was at work the other day and I realized that every time I do a call with `NSURLConnection` I have to do so much boiler plate:

1. I have to see if the data came back or not
2. I have to see if the response is of type `NSURLHttpResponse` or not and then get the status code
3. I have to check the status code and see if it's the status code I wanted (e.g. 200)
4. I have to see if an error came back. Was this a connection error. What error was this?
5. I have to enable GZIP manually on the headers
6. I have to post my header values manually in a freaking dictionary. Hello? Make this shit easier for us, Apple!
7. And a tons more...

So why is this class so dumb? Well, the people who wrote it didn't know better. That's my answer. Let me clarify, I am not saying they are stupid or anything. Nobody wakes up in the morning saying "I'm going to write some shitty code at work today". No! People aren't stupid. People do the best they can and unfortunately the best they could do was not good enough.

So I am going to change that now and create a fluent interface on top of `NSURLConnection` that will cut our boiler plate code to half, or less!

Let's begin by creating the interface of our class:

```swift
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
    return self
  }
  
  func onUnhandledHttpCode(handler: Block) -> Self{
    return self
  }
  
  func setHttpBody(body: NSData) -> Self{
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
```

So this is how I think Apple should have designed `NSURLConnection` from the beginning. With our own `FluentUrlConnection` class, we can do stuff like this:

```swift
FluentUrlConnection(urlStr: "http://vandadnp.wordpress.com")
  .ofType(.GET)
  .acceptGzip()
  .setHttpBody("hello world")
  .setHttpHeader(value: "Accept", forKey: "application/json")
  .onHttpCode(200, handler: { (sender: FluentUrlConnection) -> () in
    
  })
  .onHttpCode(401, handler: { (sender: FluentUrlConnection) -> () in
    
  })
  .onUnhandledHttpCode { (sender: FluentUrlConnection) -> () in
    
  }
  .onConnectionSuccess { (sender: FluentUrlConnection) -> () in
    
  }
  .onConnectionFailure { (sender: FluentUrlConnection) -> () in
    
  }
  .start()
```
Holy jesus, right? What happened here?

1. The instance of the `FluentUrlConnection` was created inline. No variable was used.
2. The `ofType()` function allows us to change the type of our request from `GET`, to `POST` and etc. This method returns `Self` allowing us to chanin our calls inline. Awesome, agree?
3. The `acceptGzip()` function allows us to accept Gzipped content if the server supports it. See how I did this... I didn't write a property for the connection class to enable or disable this functionality. Think about it for a second, if a functionality is by default off, and you want to allow the user to turn it on when they want, why should you expose a property to the user? Just expose a fluent function that allows the user to turn the functionality on. After turning somethin on, of course they are not going to want to turn it off again. Think about it a bit... did it drop? what? the coin I mean!
4. The `setHttpBody()` function allows the programmer to set the body of the request whenever he wants to. Not at any specific point. This can be done even later, or you can do this call twice. It is completely up to you.
5. The `onHttpCode()` function is awesome itself. It will call the given function if the connection comes back with the given http status code.
6. The `onUnhandledHttpCode()` must be my favorite. The block that is passed to this function gets called if the http status code is not handled by one of the other `onHttpCode()` functions.
7. The `onConnectionSuccess()` function is called if the connection comes back successfully. This means that the error of the connection is `nil`.
8. The `onConnectionFailure()` function is called if the connection came back with an `error`.

Please just take a few moments now and properly think about what this code is doing. Don't think about the syntax as much. Think about the fact that the fluent interface and the builder pattern used in this example code is completely abstracting the complication of writing code and is pretty much eliminating all the shitty `if` statements that we may have had to write so far with `NSURLConnection`.

Now time to implement this class, don't you agree?

1. Let's start with the implementation of the `onHttpCode()` function. This function takes in an http status code of type `Int` and a block object that should be called, if we receive the given status code. So we must save these block objects and their corresponding status codes in some sort of a dictionary where the keys to this dictionary are the status codes as `Int` and the values are the block objects. Here is that variable in our class. Put this on top of the class:

	```swift
	private lazy var httpCodeHandlers: [Int : Block] = {
	  return [Int : Block]()
	}()
	```
	and then let's code the method:
	
	```swift
	func onHttpCode(code: Int, handler: Block) -> Self{
	  httpCodeHandlers[code] = handler
	  return self
	}
	```
	
2. Then let's code the `onUnhandledHttpCode()` function. This function takes in a closure of type `Block` which we have already defined before, and will call this closure whenever an http status code which we have not handled yet is called. Let's keep a reference to this closure in a variable. So put this variable on top of your class:

	```swift
	private var unhandledHttpCodeHandler : Block?
	```
	
	and then code the method itself:
	
	```swift
	func onUnhandledHttpCode(handler: Block) -> Self{
	  unhandledHttpCodeHandler = handler
	  return self
	}
	```
	
	note how the variable is optional? this means that we may or may not have a block for unhandled http status codes.
	
3. It's time to implement the `setHttpBody()` function. This will just keep a reference to an object of type `NSData` to be sent to the server as part of the body of the request. So keep this in a varibale. Put this on top of your class code:

	```swift
	private var httpBody: NSData?
	```
	
	and then code the method:
	
	```swift
	func setHttpBody(body: NSData) -> Self{
	  httpBody = body
	  return self
	}
	```
	
	Keep in mind that we had an overloaded version of the `setHttpBody()` function that took in a raw string. Yeah, damn right. About time we stopped with rigidity in our code. Why just 	take in a freaking `NSURL` if you know most developers just have the `String` version of the `NSURL`?

4. How about the `setHttpHeader()` function now. For this, we need a dictionary that can keep track of the given header keys and values. Let's make this lazily allocated because we may not even use it eventually:

	```swift
	private lazy var httpHeaders: [String : String] = {
	  return [String : String]()
	}()
	```
	
	and then method itself of course:
	
	```swift
	func setHttpHeader(#value: String, forKey: String) -> Self{
	  httpHeaders[forKey] = value
	  return self
	}
	```
	
	__Note__: I'm going to differ the implementation of the `start()` function for later as that's the biggest function of this class.

5. The `onConnectionSuccess()` function is next up. This just keeps a reference to a block to be called if the connection doesn't give us an error back. Let's create a variable for this block object. Put this on top of your class:

	```swift
	private var connectionSuccessHandler: Block?
	```

	and then implement the method:

	```swift
	func onConnectionSuccess(handler: Block) -> Self{
	  connectionSuccessHandler = handler
	  return self
	}
	```

6. Do the same for the `onConnectionFailure()` function. This function keeps a reference to a block object to be called if the connection comes back with an error. Let's start with the reference variable:

	```swift
	private var connectionFailureHanlder: Block?
	```

	and then the function implementation:

	```swift
	func onConnectionFailure(handler: Block) -> Self{
	  connectionFailureHanlder = handler
	  return self
	}
	```
	
7. We also need to implement the `acceptGzip()` function. This function simply switches our variable on. Put the variable on top of the class:

	```swift
	private var acceptsGzip = false
	```

	and then implement the function

	```swift
	func acceptGzip() -> Self{
	  acceptsGzip = true
	  return self
	}
	```

8. And now the implementation of the mother of them all... the `start()` function. This function has to put everything together that we have done so far and then do the actual creation of the `NSURLConnection`:

	```swift
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
	```
	
	I've written some comments so that hopefully we will understand what is going on here. but I will explain:
	
	1. First we have the `handleGzipFlag()` function that goes through the http headers that we are given and if we want to enable gzip, it adds the string of `"gzip"` to the end of the 		header with the key of "Accept-Encoding". You can [read more about that on W3.org](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html).
	2. The `start()` function then uses `NSURLConnection` in the usual manner to send an __asynchronous__ request to the server.
	3. As soon as we get the response, data and the error, we save them in our url connection instance so that the programmer that uses our class can read them too if he wants to.
	4. Then we go through our http code handlers and find the one that corresponds with the current http code and then call it if it exists. If the status code was not handled and we had a 		block object to execute in the case of unhandled-http-code, then we call that block.

So now if I want to for instance get the contents of a website with the `GET` method I can just do this:

```swift
FluentUrlConnection(urlStr: "http://vandadnp.wordpress.com")
  .ofType(.GET)
  .acceptGzip()
  .onConnectionSuccess { (sender: FluentUrlConnection) -> () in
    
    if let data = sender.connectionData{
      println("Got data = \(data)")
    }
    
  }
  .onConnectionFailure { (sender: FluentUrlConnection) -> () in
    println("Failed. \(sender.connectionError)")
  }
  .start()
```

So awesome, at least I think so. Much clearner than the `NSURLConnection` equivalent of convoluted `if` statements and useless `NSURL` constructions:

Here is the same code but with pure `NSURLConnection`. Kinda disgusting:

```swift
let url = NSURL(string: "http://vandadnp.wordpress.com")!
let request = NSMutableURLRequest(URL: url)
request.allHTTPHeaderFields = ["Accept-Encoding" : "gzip"]
let queue = NSOperationQueue()

NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
  
  if error != nil{
    println("Error = \(error)")
  } else {
    
    // success
    
    if let httpResponse = response as? NSHTTPURLResponse{
      
      if (httpResponse == 200){
        
      } else {
        
      }
      
      if data != nil{
        // do something
      }
      
    }
    
  }
  
}
```

I have packaged this class up in my [open-source Swift library which is called Chorizo, under the name of `ChorizoProUrlConnection`. Check it out](https://github.com/vandadnp/chorizo). Have a look at that for more information and inspirations/ideas. I have also put the code inside the `exampleCode` folder of this folder in this repo so that's another way of getting the whole code for this class.

Task Serialization with Fluent Interfaces
===
I think fluent interfaces are amazing for chaining calls. that's what they are really good for. So let's say that you have a few tasks that you want to do serially, but some are on the main thread, some on background threads, etc. You can do this with GCD obviously but the syntax is, well, a bit weird and you will have to create serial queues and etc. Ergh, who would want to do that?

The other option is to use `NSOperationQueue` and that's pretty decent. But then again, let's have a look at some of the functions available in this class:

```swift
class NSOperationQueue : NSObject {
    
    func addOperation(op: NSOperation)
    @availability(iOS, introduced=4.0)
    func addOperations(ops: [AnyObject], waitUntilFinished wait: Bool)
    
    @availability(iOS, introduced=4.0)
    func addOperationWithBlock(block: () -> Void)
    
    var operations: [AnyObject] { get }
    @availability(iOS, introduced=4.0)
    var operationCount: Int { get }
    
    var maxConcurrentOperationCount: Int
    
    var suspended: Bool
    
    @availability(iOS, introduced=4.0)
    var name: String?
    
    @availability(iOS, introduced=8.0)
    var qualityOfService: NSQualityOfService
    
    @availability(iOS, introduced=8.0)
    unowned(unsafe) var underlyingQueue: dispatch_queue_t /* actually retain */
    
    func cancelAllOperations()
    
    func waitUntilAllOperationsAreFinished()
    
    @availability(iOS, introduced=4.0)
    class func currentQueue() -> NSOperationQueue?
    @availability(iOS, introduced=4.0)
    class func mainQueue() -> NSOperationQueue
}
```

What a shame... so many functions that return `Void`. So basicall you have to code your app like this:

```swift
queue.doThis()
queue.doSomethingElse()
queue.doBlaBla()
```

All this repitition makes me go crazy a bit. Why do I have to repeat `queue` all the time? Why do I even freaking need a variable name? No. We can make this look better. Let's start with the interface of our queue:

```swift
import Foundation

typealias FluentQueueTask = () -> ()

class FluentSerialQueue{
  
  func onBackround(task: FluentQueueTask) -> Self{
    return self
  }
  
  func onMainThread(task: FluentQueueTask) -> Self{

    return self
  }
  
  func start() -> Self{
    return self
  }
  
}
```

And we would like to be able to use this class to serially execute tasks on main and the background thread, one by one. This is how we will use it:

```swift
FluentSerialQueue().onBackround { () -> () in
  println("Background 1, thread = \(NSThread.currentThread())")
}.onMainThread { () -> () in
  println("Main 1, thread = \(NSThread.currentThread())")
}.onBackround { () -> () in
  println("Background 2, thread = \(NSThread.currentThread())")
}.onMainThread { () -> () in
  println("Main 2, thread = \(NSThread.currentThread())")
}.start()
```

Now do this with GCD, seriously. See your code, then look at this code. See your code again, and look at this code! Bear in mind that one cannot achieve the same type of elegance in code without fluent interfaces. God bless the fluent interfaces! Your code may achieve this same thing with GCD (obviously with more lines of code) but it will never be as flexible as this, in the exact same way. The calls on this class can be chained for ever basically and that's the beauty of the fluent interfaces. Now let's implement the class:

```swift
import Foundation

typealias FluentQueueTask = () -> ()

class FluentSerialQueue{
  
  private struct FluentTask{
    var block: FluentQueueTask
    var onBackgroundThread: Bool
  }
  
  private lazy var tasks: [FluentTask] = {
    return [FluentTask]()
  }()
  
  private lazy var queue = dispatch_queue_create("com.pixolity.serialQueue", DISPATCH_QUEUE_SERIAL)
  
  func onBackround(task: FluentQueueTask) -> Self{
    tasks.append(FluentTask(block: task, onBackgroundThread: true))
    return self
  }
  
  func onMainThread(task: FluentQueueTask) -> Self{
    tasks.append(FluentTask(block: task, onBackgroundThread: false))
    return self
  }
  
  func start() -> Self{
    
    for task in tasks{
      
      if task.onBackgroundThread{
        dispatch_async(queue, task.block)
      }
      else {
        
        dispatch_async(queue, { () -> Void in
          let sema = dispatch_semaphore_create(0)
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            task.block()
            dispatch_semaphore_signal(sema)
          })
          dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)
        })
        
      }
      
    }

    return self
  }
  
}
```

this is what I'm doing:

1. For every task, I am defining the block object as `FluentQueueTask`. This is a block that takes no parameters and returns nothing.
2. Internally, the class uses the `FluentTask` structure to define its tasks. This structure encapsulates the `FluentQueueTask` block and a boolean value that indicates whether the task has to be executed on a background thread or not.
3. We also have an array of tasks named `tasks`. This is just a privately and lazily allocated array of tasks.
4. The `queue` variable (it's not `let` because it is lazily allocated) is a serial GCD queue.
5. For the `onBackround()` and the `onMainThread()` functions, we are just creating new instances of the `FluentTask` structure and placing them in our array ready for execution later.
6. When the `start()` function is called and will serially execute our tasks. yes. that's a semaphore I'm using. if you know a better way of serially executing tasks on the main thread mixed with background threads, please fix this article and submit a pull request.

Conclusion
===
1. Do not return `Void` from your methods if you want to create a fluent interface. Always return `Self` as the return type and return the actual `self` as the return value.
2. In a fluent interface, when a functionality is turned off by default (`false`), do not enable this functionality through a property. Rather, create a method that returns `Self` and allows the programmer to enable the functionality. This allows for a fluent interface rather than `obj.property = value` type of old fashioned OOP programming.
3. Fluent interfaces created in the right way eliminate the need of creating a variable pointing to the original object. The object is passed to the completion blocks whenever needed.
4. Fluent interfaces mixed with the Builder pattern allow a class or a structure to Swift to encapsulate its own work within itself, and only expose logical listeners/handlers to the outside world, cutting the workd of the programmer that uses your APIs in half, getting rid of clutter and repetition in their code, getting rid of `if` statements and whatnot.
5. One of the benefits of the Builder pattern is that the class that is the builder can be passed from one function to another, one by one completing the building process. One function can call a specific method on the same builder to complete a specific task, pass the same builder to another function to continue building it until it is fully built.

References
===
1. [Builder pattern](http://en.wikipedia.org/wiki/Builder_pattern)
2. [Fluent interfaces](http://en.wikipedia.org/wiki/Fluent_interface)
3. [14 Header Field Definitions](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html)
4. [Chorizo - An open-source Swift Fluent Interface library](https://github.com/vandadnp/chorizo)
