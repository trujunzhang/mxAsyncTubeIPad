//
//  YTGridMoreCellNode.h
//  IOSTemplate
//
//  Created by djzhang on 11/17/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "YoutubeConstants.h"


@interface YoutubeVideoCache : MABYT3_Video
@property(nonatomic) BOOL hasImage;
@property(nonatomic, strong) UIImageView * image;

@property(nonatomic, copy) NSString * channelThumbnailUrl;
@end
