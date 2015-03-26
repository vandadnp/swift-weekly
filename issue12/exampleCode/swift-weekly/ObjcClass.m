//
//  ObjcClass.m
//  swift-weekly
//
//  Created by Vandad on 3/26/15.
//  Copyright (c) 2015 com.pixolity.ios. All rights reserved.
//

#import "ObjcClass.h"

extern NSInteger addMethod(NSInteger a, NSInteger b);

@implementation ObjcClass

//NSInteger addMethod(NSInteger a, NSInteger b){
//    return a + b;
//}

- (NSInteger) add:(NSInteger)a b:(NSInteger)b{
    return addMethod(a, b);
}

@end
