//
//  ViewController.swift
//  swift-weekly
//
//  Created by vandadnp on 12/22/14.
//  Copyright (c) 2014 com.pixolity.ios. All rights reserved.
//

import UIKit

extension UIImage{
    var width: CGFloat{get{return self.size.width}}
    var height: CGFloat{get{return self.size.height}}
}

infix operator +{associativity left}
func +(l: UIImage, r: UIImage) -> UIImage{
    let s = CGSize(width: l.width + r.width, height: l.height > r.height ? l.height : r.height)
    UIGraphicsBeginImageContextWithOptions(s, true, 0.0)
    l.drawAtPoint(CGPointZero)
    r.drawAtPoint(CGPoint(x: l.width, y: 0.0))
    let i = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return i
}


class ViewController: UIViewController {
    
    func example1(){
        let img1 = UIImage(named: "1")!
        let img2 = UIImage(named: "2")!
        let mix = img1 + img2
    }
    
    func example2(){
        let p = CGPoint(x: 0, y: 0)
        var i = UIImage(named: "1")!
        i.drawAtPoint(p)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        example1()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

