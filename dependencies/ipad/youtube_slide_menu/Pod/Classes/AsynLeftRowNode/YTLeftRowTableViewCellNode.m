//
//  YTLeftRowTableViewCellNode.m
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "YTLeftRowTableViewCellNode.h"
#import "FrameCalculator.h"
#import "Foundation.h"
#import "ASCacheNetworkImageNode.h"

static CGFloat ROW_TITLE_FONT_SIZE = 16;


@interface YTLeftRowTableViewCellNode () {

}

@property(nonatomic, strong) ASCacheNetworkImageNode * videoChannelThumbnailsNode;
@property(nonatomic, strong) ASTextNode * channelTitleTextNode;

@end


@implementation YTLeftRowTableViewCellNode

- (instancetype)initWithNodeCellSize:(struct CGSize const)nodeCellSize lineTitle:(NSString *)lineTitle lineIconUrl:(NSString *)lineIconUrl isRemoteImage:(BOOL)isRemoteImage {
   self = [super init];
   if (self) {
      self.nodeCellSize = nodeCellSize;
      self.lineTitle = lineTitle;
      self.lineIconUrl = lineIconUrl;
      self.isRemoteImage = isRemoteImage;

      [self rowThirdForChannelInfo];
      [self layoutSubNodes];
      [self setupAllNodesEffect];
   }

   return self;
}


#pragma mark -
#pragma mark Setup sub nodes.


- (void)setupAllNodesEffect {

   // 1
   self.layerBacked = true;
   self.backgroundColor = [UIColor clearColor];

   [self effectThirdForChannelInfo];
}


- (void)layoutSubNodes {
   //MARK: Node Layout Section
   self.frame = [FrameCalculator frameForContainer:self.nodeCellSize];

   [self layoutThirdForChannelInfo];
}


#pragma mark -
#pragma mark third row for channel title.(Row N03)


- (void)rowThirdForChannelInfo {
   // 1
   [self showSubscriptionThumbnail];
   // 2
   self.channelTitleTextNode = [[ASTextNode alloc] init];
   self.channelTitleTextNode.attributedString = [NSAttributedString attributedStringForLeftMenuSubscriptionTitleText:self.lineTitle
                                                                                                            fontSize:ROW_TITLE_FONT_SIZE];

   [self addSubnode:self.channelTitleTextNode];
}


- (void)showSubscriptionThumbnail {
   if (self.isRemoteImage) {
      ASCacheNetworkImageNode * cacheNetworkImageNode = [[ASCacheNetworkImageNode alloc] initForImageCache];
      [cacheNetworkImageNode startFetchImageWithString:self.lineIconUrl];

      self.videoChannelThumbnailsNode = cacheNetworkImageNode;
   } else {
      ASImageNode * localImageNode = [[ASImageNode alloc] init];
      localImageNode.image = [UIImage imageNamed:self.lineIconUrl];

      self.videoChannelThumbnailsNode = localImageNode;
   }

   [self addSubnode:self.videoChannelThumbnailsNode];
}


- (void)layoutThirdForChannelInfo {
   self.videoChannelThumbnailsNode.frame = [FrameCalculator frameForLeftMenuSubscriptionThumbnail:self.nodeCellSize];


   self.channelTitleTextNode.frame =
    [FrameCalculator frameForLeftMenuSubscriptionTitleText:self.nodeCellSize
                                             leftNodeFrame:self.videoChannelThumbnailsNode.frame
                                            withFontHeight:ROW_TITLE_FONT_SIZE];

}


- (void)effectThirdForChannelInfo {
   // 4
   self.videoChannelThumbnailsNode.layerBacked = true;
   if (self.isRemoteImage) {
      self.videoChannelThumbnailsNode.imageModificationBlock = ^UIImage *(UIImage * image) {
          UIImage * modifiedImage = nil;
          CGRect rect = (CGRect) { CGPointZero, image.size };

          UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);

          [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4.0] addClip];
          [image drawInRect:rect];
          modifiedImage = UIGraphicsGetImageFromCurrentImageContext();

          UIGraphicsEndImageContext();

          return modifiedImage;
      };
   }

   // 3
   self.channelTitleTextNode.layerBacked = true;
   self.channelTitleTextNode.backgroundColor = [UIColor clearColor];
}


@end
