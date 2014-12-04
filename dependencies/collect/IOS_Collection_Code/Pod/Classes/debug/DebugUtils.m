//
//  DebugUtils.m
//  IOSTemplate
//
//  Created by djzhang on 10/24/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "DebugUtils.h"


@implementation DebugUtils

+ (void)printFrameInfo:(CGRect)frame withControllerName:(NSString *)controllerName {
   CGFloat x = frame.origin.x;
   CGFloat y = frame.origin.y;
   CGFloat w = frame.size.width;
   CGFloat h = frame.size.height;

   NSLog([NSString stringWithFormat:@"    %@     ", controllerName]);
   NSLog(@"x = %f", x);
   NSLog(@"y = %f", y);
   NSLog(@"w = %f", w);
   NSLog(@"h = %f", h);
}

@end
