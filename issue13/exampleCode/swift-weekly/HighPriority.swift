//
//  HighPriority.swift
//  swift-weekly
//
//  Created by Vandad NP on 1/19/18.
//  Copyright © 2018 Pixolity Ltd. All rights reserved.
//

import Foundation

private extension Array where Element == CFAbsoluteTime {
    var mean: CFAbsoluteTime {
        return reduce(0) {$0 + $1} / CFAbsoluteTime(count)
    }
}

class HighPriority {
    
    typealias Task = () -> Void
    let task: Task
    
    init(task: @escaping Task) {
        self.task = task
    }
    
    private lazy var queue: DispatchQueue = {
        return DispatchQueue(label: UUID().uuidString,
                             qos: DispatchQoS.userInteractive,
                             attributes: .concurrent,
                             autoreleaseFrequency: .inherit,
                             target: nil)
    }()
    
    typealias PerformCompletion = (CFAbsoluteTime) -> Void
    
    func perform(completion: @escaping PerformCompletion) {
        
        //perform 3 times, and get an average performance
        var times = [CFAbsoluteTime]()
        
        internalPerform(completion: {time in
            times.append(time)
            self.internalPerform(completion: {time in
                times.append(time)
                self.internalPerform(completion: {time in
                    times.append(time)
                    let mean = times.mean
                    completion(mean)
                })
            })
        })
        
        
    }
    
    @inline(__always)
    private func internalPerform(completion: @escaping PerformCompletion) {
        
        queue.async {
            let start = CFAbsoluteTimeGetCurrent()
            self.task()
            let end = CFAbsoluteTimeGetCurrent()
            let delta = end - start
            DispatchQueue.main.async {
                completion(delta)
            }
        }
        
    }
    
}
