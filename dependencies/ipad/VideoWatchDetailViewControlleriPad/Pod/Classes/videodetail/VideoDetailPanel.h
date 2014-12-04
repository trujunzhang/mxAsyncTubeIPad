//
//  VideoDetailPanel.h
//  YoutubeDetailRotateTabbarsApp
//
//  Created by djzhang on 10/9/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YoutubeConstants.h"

@class YTYouTubeVideoCache;


@interface VideoDetailPanel : UIView

@property(nonatomic, strong) YTYouTubeVideoCache * videoCache;

- (instancetype)initWithVideo:(YTYouTubeVideoCache *)videoCache;

- (void)bind:(YTYouTubeVideoCache *)videoCache;

@end
