//
//  YoutubeResponseInfo.m
//  IOSTemplate
//
//  Created by djzhang on 11/21/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YoutubeResponseInfo.h"


@implementation YoutubeResponseInfo

- (instancetype)initWithArray:(NSMutableArray *)array pageToken:(NSString *)pageToken {
   self = [super init];
   if (self) {
      self.array = array;
      self.pageToken = pageToken;
   }

   return self;
}


+ (instancetype)infoWithArray:(NSMutableArray *)array pageToken:(NSString *)pageToken {
   return [[self alloc] initWithArray:array pageToken:pageToken];
}


@end
