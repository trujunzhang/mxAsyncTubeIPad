//
//  ASCacheNetworkImageNode.m
//  IOSTemplate
//
//  Created by djzhang on 10/24/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "AsyncDisplayKitStatic.h"


@implementation ASTextNode (custom)


+ (NSAttributedString *)initWithAttributedString:(NSAttributedString *)attributedString {
   ASTextNode * textNode = [[ASTextNode alloc] init];
   textNode.attributedString = attributedString;

   return textNode;
}

@end
