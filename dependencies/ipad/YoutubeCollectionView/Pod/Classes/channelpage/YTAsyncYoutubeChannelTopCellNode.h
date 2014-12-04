//
//  YTAsyncYoutubeChannelTopCellNode.h
//  IOSTemplate
//
//  Created by djzhang on 11/12/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoutubeConstants.h"

#import "AsyncDisplayKit.h"
#import "ASControlNode+Subclasses.h"
#import "ASDisplayNode+Subclasses.h"
@class ASCacheNetworkImageNode;


@interface YTAsyncYoutubeChannelTopCellNode : ASDisplayNode

@property(nonatomic, strong) YTYouTubeSubscription * subscription;
@property(nonatomic, strong) YTYouTubeChannel * currentChannel;

- (instancetype)initWithSubscription:(GTLYouTubeSubscription *)subscription cellSize:(CGSize)cellSize;
- (void)layoutNodes:(CGSize)cellSize;

@end
