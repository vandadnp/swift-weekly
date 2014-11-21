//
//  FluentQueue.swift
//  swift-weekly
//
//  Created by Vandad NP on 11/21/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//

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