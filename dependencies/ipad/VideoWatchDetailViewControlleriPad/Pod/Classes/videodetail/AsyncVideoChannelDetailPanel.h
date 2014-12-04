//
//  AsyncVideoChannelDetailPanel.h
//  YoutubePlayApp
//
//  Created by djzhang on 10/14/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncDisplayKit.h"
@class YoutubeVideoCache;


@interface AsyncVideoChannelDetailPanel : ASCellNode

@property(nonatomic, strong) YoutubeVideoCache * cardInfo;
- (instancetype)initWithVideo:(YoutubeVideoCache *)videoCache;

@end
