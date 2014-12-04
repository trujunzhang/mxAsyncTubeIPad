//
//  IpadGridViewUserCell.m
//  IOSTemplate
//
//  Created by djzhang on 10/23/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "IpadGridViewUserCell.h"


@implementation IpadGridViewUserCell


- (void)bind:(YTYouTubeVideoCache *)video {
   // 4
   [self.userNameLabel setText:video.snippet.channelTitle];
}
@end
