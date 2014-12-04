//
//  YTAsyncGridViewVideoNode.m
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <YoutubeCollectionView/IpadGridViewCell.h>
#import "YTAsyncGridViewVideoNode.h"
#import "FrameCalculator.h"
#import "AnimatedContentsDisplayLayer.h"
#import "Foundation.h"
#import "HexColor.h"
#import "UIColor+iOS8Colors.h"
#import "YoutubeParser.h"
#import "ASCacheNetworkImageNode.h"
#import "GYoutubeHelper.h"


static const int FIRST_ROW_HEIGHT = 142;
static const int THIRD_ROW_HEIGHT = 28;


@interface YTAsyncGridViewVideoNode () {

}
@property(nonatomic) CGFloat durationLabelWidth;

@property(nonatomic, strong) ASNetworkImageNode * videoCoverThumbnailsNode;
@property(nonatomic, strong) ASTextNode * durationTextNode;

@property(nonatomic, strong) ASTextNode * videoTitleTextNode;

@property(nonatomic, strong) ASCacheNetworkImageNode * videoChannelThumbnailsNode;
@property(nonatomic, strong) ASTextNode * channelTitleTextNode;


@property(nonatomic, strong) ASDisplayNode * divider;


@end


@implementation YTAsyncGridViewVideoNode

- (instancetype)initWithCardInfo:(YTYouTubeVideoCache *)cardInfo cellSize:(CGSize)cellSize delegate:(id<IpadGridViewCellDelegate>)delegate {
   self = [super initWithLayerClass:[AnimatedContentsDisplayLayer class]];
   if (self) {
      self.nodeCellSize = cellSize;
      self.cardInfo = cardInfo;
      self.delegate = delegate;

      [self setupContainerNode];
      [self layoutSubNodes];

      [self setupAllNodesEffect];
   }

   return self;
}


#pragma mark -
#pragma mark Setup sub nodes.


- (void)setupContainerNode {
   [self rowFirstForChannelClover];
   [self rowSecondForChannelTitle];
   [self rowThirdForChannelInfo];
}


- (void)setupAllNodesEffect {

   // 1
   self.layerBacked = true;

   // 1.1
   self.backgroundColor = [UIColor whiteColor];

   // 1.2
//   self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.root.view.bounds].CGPath;
   self.shadowColor = [UIColor colorWithHexString:@"B5B5B5" alpha:0.8].CGColor;
   self.shadowOffset = CGSizeMake(1, 3);
   self.shadowOpacity = 1.0;
   self.shadowRadius = 2.0;

   [self effectFirstForChannelClover];
   [self effectSecondForChannelTitle];
   [self effectThirdForChannelInfo];
}


- (void)layoutSubNodes {
   //MARK: Node Layout Section
   self.frame = [FrameCalculator frameForContainer:self.nodeCellSize];

   [self layoutFirstForChannelClover];
   [self layoutSecondForChannelTitle];
   [self layoutThirdForChannelInfo];
}


#pragma mark -
#pragma mark first row for channel clover.(Row N01)


- (void)rowFirstForChannelClover {
   NSString * videoThumbnailsUrl = [YoutubeParser getVideoSnippetThumbnails:self.cardInfo];

   // 1
   ASCacheNetworkImageNode * videoChannelThumbnailsNode = [[ASCacheNetworkImageNode alloc] initForImageCache];
   [videoChannelThumbnailsNode startFetchImageWithString:videoThumbnailsUrl];

   // configure the button
   videoChannelThumbnailsNode.userInteractionEnabled = YES; // opt into touch handling
   [videoChannelThumbnailsNode addTarget:self
                                  action:@selector(channelThumbnailsTapped:)
                        forControlEvents:ASControlNodeEventTouchUpInside];

   self.videoCoverThumbnailsNode = videoChannelThumbnailsNode;
   [self addSubnode:self.videoCoverThumbnailsNode];

   // 2
   NSString * durationString = [YoutubeParser getVideoDurationForVideoInfo:self.cardInfo];
//   NSLog(@"durationString = %@", durationString);
   self.durationLabelWidth = [FrameCalculator calculateWidthForDurationLabel:durationString];

   ASTextNode * durationTextNode = [[ASTextNode alloc] init];
   durationTextNode.backgroundColor = [UIColor colorWithHexString:@"1F1F21" alpha:0.6];
   durationTextNode.attributedString = [NSAttributedString attributedStringForDurationText:durationString];

   self.durationTextNode = durationTextNode;
   [self addSubnode:self.durationTextNode];
}


- (void)layoutFirstForChannelClover {
   self.videoCoverThumbnailsNode.frame = [FrameCalculator frameForChannelThumbnails:self.nodeCellSize
                                                                    nodeFrameHeight:142.0f];

   self.durationTextNode.frame = [FrameCalculator frameForDurationWithCloverSize:self.videoCoverThumbnailsNode.frame.size
                                                               withDurationWidth:self.durationLabelWidth];
}


- (void)effectFirstForChannelClover {
   // 2
   self.videoCoverThumbnailsNode.layerBacked = true;
   self.videoCoverThumbnailsNode.contentMode = UIViewContentModeScaleAspectFit;// .ScaleAspectFit

   // 2.1
   self.videoCoverThumbnailsNode.backgroundColor = [UIColor iOS8silverGradientStartColor];

   // 2.2
   self.videoCoverThumbnailsNode.borderColor = [UIColor colorWithHexString:@"DDD"].CGColor;
   self.videoCoverThumbnailsNode.borderWidth = 1;

   self.videoCoverThumbnailsNode.shadowColor = [UIColor colorWithHexString:@"B5B5B5"].CGColor;
   self.videoCoverThumbnailsNode.shadowOffset = CGSizeMake(1, 3);
   self.videoCoverThumbnailsNode.shadowRadius = 2.0;


   // 3
   self.durationTextNode.layerBacked = true;
}


- (void)channelThumbnailsTapped:(id)buttonTapped {
   [self.delegate gridViewCellTap:self.cardInfo];
}


#pragma mark -
#pragma mark second row for channel title.(Row N02)


- (void)rowSecondForChannelTitle {
   NSString * videoTitleValue = self.cardInfo.snippet.title;
   // 2
   ASTextNode * titleTextNode = [[ASTextNode alloc] init];
   titleTextNode.attributedString = [NSAttributedString attributedStringForTitleText:videoTitleValue];

   //MARK: Container Node Creation Section
   self.videoTitleTextNode = titleTextNode;
   [self addSubnode:self.videoTitleTextNode];

   // hairline cell separator
   self.divider = [[ASDisplayNode alloc] init];
   self.divider.backgroundColor = [UIColor colorWithHexString:@"EAEAEA" alpha:1.0];
   [self addSubnode:self.divider];
}


- (void)layoutSecondForChannelTitle {
   self.videoTitleTextNode.frame = [FrameCalculator frameForTitleText:self.bounds
                                                    featureImageFrame:self.videoCoverThumbnailsNode.frame];
   self.divider.frame = [FrameCalculator frameForDivider:self.bounds
                                          thirdRowHeight:THIRD_ROW_HEIGHT];
}


- (void)effectSecondForChannelTitle {
   // 3
   self.videoTitleTextNode.layerBacked = true;
   self.videoTitleTextNode.backgroundColor = [UIColor clearColor];

   // 4
   self.divider.layerBacked = true;
}


#pragma mark -
#pragma mark second row for channel title.(Row N02)


- (void)rowThirdForChannelInfo {
   // 1
   [self showChannelThumbnail:[YoutubeParser getChannelIdByVideo:self.cardInfo]];

   NSString * channelTitleValue = self.cardInfo.snippet.channelTitle;
   // 2
   ASTextNode * channelTitleTextNode = [[ASTextNode alloc] init];
   channelTitleTextNode.attributedString = [NSAttributedString attributedStringForChannelTitleText:channelTitleValue];

   //MARK: Container Node Creation Section
   self.channelTitleTextNode = channelTitleTextNode;
   [self addSubnode:self.channelTitleTextNode];
}


- (void)showChannelThumbnail:(NSString *)channelId {
   // 1
   self.videoChannelThumbnailsNode = [[ASCacheNetworkImageNode alloc] initForImageCache];
   if (self.cardInfo.channelThumbnailUrl) {
      [self.videoChannelThumbnailsNode startFetchImageWithString:self.cardInfo.channelThumbnailUrl];
      return;
   }

   YoutubeResponseBlock completionBlock = ^(NSArray * array, NSObject * respObject) {
       self.cardInfo.channelThumbnailUrl = respObject;
       [self.videoChannelThumbnailsNode startFetchImageWithString:self.cardInfo.channelThumbnailUrl];
   };
   [[GYoutubeHelper getInstance] fetchChannelThumbnailsWithChannelId:channelId
                                                          completion:completionBlock
                                                        errorHandler:nil];

   [self addSubnode:self.videoChannelThumbnailsNode];
}


- (void)layoutThirdForChannelInfo {
   self.videoChannelThumbnailsNode.frame = [FrameCalculator frameForChannelThumbnail:self.bounds
                                                                      thirdRowHeight:THIRD_ROW_HEIGHT];

   self.channelTitleTextNode.frame = [FrameCalculator frameForChannelTitleText:self.bounds
                                                                thirdRowHeight:THIRD_ROW_HEIGHT
                                                                 leftNodeFrame:self.videoChannelThumbnailsNode.frame];
}


- (void)effectThirdForChannelInfo {
   // 4
   self.videoChannelThumbnailsNode.layerBacked = true;

   // 3
   self.channelTitleTextNode.layerBacked = true;
   self.channelTitleTextNode.backgroundColor = [UIColor clearColor];
}


@end
