//
//  VideoDetailViewControlleriPad.h
//  YoutubePlayApp
//
//  Created by djzhang on 10/20/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MediaPlayer.h>
#import "YoutubeConstants.h"
#import "CollectionConstant.h"

@class YKYouTubeVideo;

@protocol IpadGridViewCellDelegate;
@class VideoDetailViewController;
@class GGTabBarController;


@interface VideoDetailViewControlleriPad : UIViewController
@property(nonatomic, strong) UIViewController * selectedController;

@property(nonatomic, assign) id<IpadGridViewCellDelegate> delegate;
@property(nonatomic, strong) YTYouTubeVideoCache * video;

@property(nonatomic, strong) VideoDetailViewController * videoDetailController;
@property(nonatomic, strong) GGTabBarController * videoTabBarController;

@property(nonatomic, strong) UIViewController * firstViewController;
@property(nonatomic, strong) UIViewController * secondViewController;
@property(nonatomic, strong) YTCollectionViewController * thirdViewController;

@property(nonatomic, strong) YKYouTubeVideo * youTubeVideo;
- (instancetype)initWithDelegate:(id<IpadGridViewCellDelegate>)delegate video:(YTYouTubeVideoCache *)video;

@end


