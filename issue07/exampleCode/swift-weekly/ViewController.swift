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

//the ^ operator on String
postfix operator ^{}
postfix func ^(s: String) -> UIImage{
if let i = UIImage(named: s){
    return i
} else {
        //in case we cannot find the image, create a red stretchable pixel
        let r = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(r.size, true, 0)
        let c = UIGraphicsGetCurrentContext()
        UIColor.redColor().setFill()
        CGContextFillRect(c, r)
        let i = UIGraphicsGetImageFromCurrentImageContext().resizableImageWithCapInsets(UIEdgeInsetsZero, resizingMode: .Tile)
        UIGraphicsEndImageContext()
        return i
    }
}

// the >>> operator on UIImage
infix operator >>> {associativity left}
func >>> (i: UIImage, v: UIView){
    let iv = UIImageView(image: i)
    iv.center = v.center
    v.addSubview(iv)
}

class ViewController: UIViewController {
    
    func example1(){
        let img1 = UIImage(named: "1")!
        let img2 = UIImage(named: "2")!
        let mix = img1 + img2
    }
    
    func example2(){
        "1"^ >>> view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        example2()
    }

}

