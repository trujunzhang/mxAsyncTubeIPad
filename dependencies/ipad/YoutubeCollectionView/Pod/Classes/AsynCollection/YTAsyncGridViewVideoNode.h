//
//  YTAsyncGridViewVideoNode.h
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AsyncDisplayKit.h"
#import "YoutubeConstants.h"

@class GradientNode;


@interface YTAsyncGridViewVideoNode : ASDisplayNode

@property(nonatomic) CGSize const nodeCellSize;

@property(nonatomic, strong) YTYouTubeVideoCache * cardInfo;

@property(nonatomic, strong) id<IpadGridViewCellDelegate> delegate;

- (instancetype)initWithCardInfo:(YTYouTubeVideoCache *)cardInfo cellSize:(CGSize)cellSize delegate:(id<IpadGridViewCellDelegate>)delegate;
@end
