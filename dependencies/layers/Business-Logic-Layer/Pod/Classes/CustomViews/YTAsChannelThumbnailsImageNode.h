//
//  YTAsChannelThumbnailsImageNode.h
//  IOSTemplate
//
//  Created by djzhang on 10/24/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASCacheNetworkImageNode.h"

static const int FIRST_ROW_HEIGHT = 142;
static const int THIRD_ROW_HEIGHT = 28;


@interface YTAsChannelThumbnailsImageNode : ASCacheNetworkImageNode

@property(nonatomic, strong) NSString * channelId;
+ (instancetype)nodeWithChannelId:(NSString *)channelId;

@end
