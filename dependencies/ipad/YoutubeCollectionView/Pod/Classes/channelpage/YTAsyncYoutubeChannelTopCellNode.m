//
//  YTAsyncYoutubeChannelTopCellNode.m
//  IOSTemplate
//
//  Created by djzhang on 11/12/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <google-api-services-youtube/GYoutubeHelper.h>
#import "YTAsyncYoutubeChannelTopCellNode.h"

#import "YoutubeParser.h"
#import "FrameCalculator.h"
#import "ASCacheNetworkImageNode.h"
#import "HexColor.h"
#import "UIColor+iOS8Colors.h"
#import "Foundation.h"

static const int TOP_CHANNEL_SECOND_ROW_HEIGHT = 48;


@interface YTAsyncYoutubeChannelTopCellNode () {
}
@property(nonatomic) CGSize nodeCellSize;

// line01
@property(nonatomic, strong) ASImageNode * channelBannerThumbnailNode;
@property(nonatomic, strong) ASImageNode * channelThumbnailsNode;

// line02
@property(nonatomic, strong) ASTextNode * channelTitleTextNode;
@property(nonatomic, strong) ASTextNode * channelSubscriptionCountTextNode;
@end


@implementation YTAsyncYoutubeChannelTopCellNode

- (instancetype)initWithChannel:(YTYouTubeChannel *)channel cellSize:(CGSize)cellSize {
   self = [super init];
   if (self) {
      self.pageChannel = channel;
      self.nodeCellSize = cellSize;

      [self setupContainerNode];
      [self setupAllNodesEffect];
   }

   return self;
}


// do as little work as possible in main-thread layout
//856,135 (horizontal)
//600,135 (vertical)
- (void)layoutNodes:(CGSize)cellSize {
   self.nodeCellSize = cellSize;
   [self layoutSubNodes];

//   NSLog(@"Pretty printed size: %@", NSStringFromCGSize(cellSize));
//   NSString * debug = @"debug";
}


#pragma mark -
#pragma mark Setup sub nodes.


- (void)setupContainerNode {
   [self rowFirstForChannelBanner];
   [self rowSecondForChannelInfo];
}


- (void)setupAllNodesEffect {

   // 1.1
   self.backgroundColor = [UIColor whiteColor];

   // 1.2
   self.shadowColor = [UIColor colorWithHexString:@"B5B5B5" alpha:0.8].CGColor;
   self.shadowOffset = CGSizeMake(1, 3);
   self.shadowOpacity = 1.0;
   self.shadowRadius = 2.0;

   [self effectFirstForChannelBanner];
   [self effectThirdForChannelInfo];
}


- (void)layoutSubNodes {
   //MARK: Node Layout Section
   self.frame = [FrameCalculator frameForContainer:self.nodeCellSize];

   [self layoutFirstForChannelBanner];
   [self layoutThirdForChannelInfo];
}


#pragma mark -
#pragma mark first row for channel clover.(Row N01)


- (void)rowFirstForChannelBanner {
   ASCacheNetworkImageNode * channelBannerThumbnailNode =
    [[ASCacheNetworkImageNode alloc] initWithPlaceHolder:[UIImage imageNamed:@"channel_default_banner.jpg"]];
   [channelBannerThumbnailNode startFetchImageWithString:[YoutubeParser getChannelBannerImageUrl:self.pageChannel]];

   self.channelBannerThumbnailNode = channelBannerThumbnailNode;
   [self addSubnode:self.channelBannerThumbnailNode];

   // 2
   [self showChannelThumbnail:[YoutubeParser getChannelSnippetThumbnail:self.pageChannel]];
}


- (void)showChannelThumbnail:(NSString *)channelThumbnailUrl {
   ASCacheNetworkImageNode * channelThumbnailsNode = [[ASCacheNetworkImageNode alloc] initForImageCache];
   [channelThumbnailsNode startFetchImageWithString:channelThumbnailUrl];

   self.channelThumbnailsNode = channelThumbnailsNode;
   [self addSubnode:self.channelThumbnailsNode];
}


- (void)layoutFirstForChannelBanner {
   self.channelBannerThumbnailNode.frame = [FrameCalculator frameForPageChannelBannerThumbnails:self.nodeCellSize
                                                                           secondRowFrameHeight:TOP_CHANNEL_SECOND_ROW_HEIGHT];
   self.channelThumbnailsNode.frame = [FrameCalculator frameForPageChannelThumbnails:self.channelBannerThumbnailNode.frame.size];
}


- (void)effectFirstForChannelBanner {
   self.channelBannerThumbnailNode.contentMode = UIViewContentModeScaleToFill;
}


#pragma mark -
#pragma mark second row for channel title.(Row N02)


- (void)rowSecondForChannelInfo {
   // 1
   ASTextNode * channelTitleTextNode = [[ASTextNode alloc] init];
   channelTitleTextNode.attributedString =
    [NSAttributedString attributedStringForPageChannelTitleText:[YoutubeParser getChannelBrandingSettingsTitle:self.pageChannel]];

   //MARK: Container Node Creation Section
   self.channelTitleTextNode = channelTitleTextNode;
   [self addSubnode:self.channelTitleTextNode];

   // 2
   ASTextNode * channelSubscriptionCountTextNode = [[ASTextNode alloc] init];
   channelSubscriptionCountTextNode.attributedString =
    [NSAttributedString attributedStringForChannelStatisticsSubscriberCount:[YoutubeParser getChannelStatisticsSubscriberCount:self.pageChannel]];

   //MARK: Container Node Creation Section
   self.channelSubscriptionCountTextNode = channelSubscriptionCountTextNode;
   [self addSubnode:self.channelSubscriptionCountTextNode];

}


- (void)layoutThirdForChannelInfo {
   self.channelTitleTextNode.frame = [FrameCalculator frameForPageChannelTitle:self.nodeCellSize
                                                          secondRowFrameHeight:TOP_CHANNEL_SECOND_ROW_HEIGHT];

   self.channelSubscriptionCountTextNode.frame =
    [FrameCalculator frameForPageChannelStatisticsSubscriberCount:self.nodeCellSize
                                             secondRowFrameHeight:TOP_CHANNEL_SECOND_ROW_HEIGHT];

}


- (void)effectThirdForChannelInfo {
   // 3
   self.channelTitleTextNode.backgroundColor = [UIColor clearColor];
}


@end
