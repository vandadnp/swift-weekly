//
//  ViewController.swift
//  swift-weekly
//
//  Created by vandadnp on 18/02/15.
//  Copyright (c) 2015 com.pixolity.ios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    func example1(){
        
        let p = CGPoint(x: 0xaaaaaaaa, y: 0xbbbbbbbb)
        let f = view.frame
        let fs = f.size
        
        switch (p.x, p.y){
        case (0xabcdefc, 0):
            println(0xabcdefc)
        case (fs.width, 0xabcdefe):
            println(0xabcdefe)
        case (0xabcdeff, fs.height):
            println(0xabcdeff)
        default:
            println(0xffffffff)
        }
        
    }
    
//    func example2(){
//        
//        let age = 2
//        
//        switch age{
//        case 0...2:
//            println("toddler")
//        case 3...14:
//            println("child")
//        case 15...17:
//            println("teenager")
//        default:
//            println("adult")
//        }
//        
//    }
//    
//    func example3(){
//        
//        class Vehicle{
//            let name: String
//            let wheels: Int
//            init(name: String, wheels: Int){
//                self.name = name
//                self.wheels = wheels
//            }
//        }
//        
//        class Bicycle: Vehicle{
//            convenience init(){self.init(name: "Bicycle", wheels: 2)}
//        }
//        
//        class Car: Vehicle{
//            convenience init(){self.init(name: "Car", wheels: 4)}
//        }
//        
//        class AlienCar: Vehicle{
//            convenience init(){self.init(name: "Blabla", wheels: -1)} //-1 wheels!!!
//        }
//        
//        let vehicles = [Car(), Bicycle(), Car(), AlienCar()]
//        for v in vehicles{
//            switch (v.name, v.wheels){
//            case (_, let wheels) where wheels >= 5:
//                println("You are a vehicle with more than 4 wheels. Your name isn't important to me")
//            case (let name, 4):
//                println("You have 4 wheels and your name is \(name)")
//            case let (_, 2):
//                println("You have 2 wheels, you are a bicycle")
//            case (let name, 1):
//                println("You are a single wheeler and your name is \(name)")
//            default:
//                println("I have no clue what type of a vehicle you are and have no access to your name!")
//            }
//        }
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        example1()
    }
    
}

