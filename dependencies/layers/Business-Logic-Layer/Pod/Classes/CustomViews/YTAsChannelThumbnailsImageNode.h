//
//  YTAsChannelThumbnailsImageNode.h
//  IOSTemplate
//
//  Created by djzhang on 10/24/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASCacheNetworkImageNode.h"


@interface YTAsChannelThumbnailsImageNode : ASCacheNetworkImageNode

@property(nonatomic, strong) NSString * channelId;
- (instancetype)initWithChannelId:(NSString *)channelId;
+ (instancetype)nodeWithChannelId:(NSString *)channelId;


@end
