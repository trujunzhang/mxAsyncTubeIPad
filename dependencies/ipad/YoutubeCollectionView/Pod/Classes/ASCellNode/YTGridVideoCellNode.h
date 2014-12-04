//
//  YTGridVideoCellNode.h
//  IOSTemplate
//
//  Created by djzhang on 11/17/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "YoutubeConstants.h"
@protocol IpadGridViewCellDelegate;


@interface YTGridVideoCellNode : ASCellNode

- (instancetype)initWithCellNodeOfSize:(CGSize)size;

@property(nonatomic, strong) YTYouTubeVideoCache * video;
@property(nonatomic, strong) id<IpadGridViewCellDelegate> delegate;
- (void)bind:(YTYouTubeVideoCache *)video placeholderImage:(UIImage *)placeholder delegate:(id<IpadGridViewCellDelegate>)delegate;
@end
