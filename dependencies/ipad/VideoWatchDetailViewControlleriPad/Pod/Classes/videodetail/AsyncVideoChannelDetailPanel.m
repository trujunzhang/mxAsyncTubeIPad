//
//  AsyncVideoChannelDetailPanel.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/14/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "AsyncVideoChannelDetailPanel.h"
#import "YoutubeVideoCache.h"
#import "YoutubeParser.h"
#import "ASCacheNetworkImageNode.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <AsyncDisplayKit/ASHighlightOverlayLayer.h>
#import <google-api-services-youtube/GYoutubeHelper.h>


static CGFloat kTextPadding = 10.0f;


@interface AsyncVideoChannelDetailPanel () {
   ASTextNode * _textNode;
   ASDisplayNode * _divider;
}

@property(nonatomic, strong) ASCacheNetworkImageNode * videoChannelThumbnailsNode;
@end


@implementation AsyncVideoChannelDetailPanel


- (instancetype)initWithVideo:(YoutubeVideoCache *)videoCache {
   if (!(self = [super init]))
      return nil;

   self.cardInfo = videoCache;

   self.backgroundColor = [UIColor whiteColor];

   [self setupContainerNode];
   [self addSubnode:self.videoChannelThumbnailsNode];

   // create a text node
   _textNode = [[ASTextNode alloc] init];

   // generate an attributed string using the custom link attribute specified above
//   NSString * blurb = @"kittens courtesy placekitten.com kittens courtesy placekitten.com kittens courtesy placekitten.com \U0001F638";
   NSString * blurb = videoCache.snippet.channelTitle;
   NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:blurb];
   [string addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]
                  range:NSMakeRange(0, blurb.length)];
   [string addAttributes:@{
     NSForegroundColorAttributeName : [UIColor grayColor],
     NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternDot),
    }
                   range:[blurb rangeOfString:@"placekitten.com"]];
   _textNode.attributedString = string;

   // add it as a subnode, and we're done
   [self addSubnode:_textNode];

   // hairline cell separator
   _divider = [[ASDisplayNode alloc] init];
   _divider.backgroundColor = [UIColor lightGrayColor];
   [self addSubnode:_divider];

   return self;
}


- (void)setupContainerNode {
   NSString * videoTitleValue = self.cardInfo.snippet.title;
   NSString * channelTitleValue = self.cardInfo.snippet.channelTitle;
   // 1
   ASCacheNetworkImageNode * videoChannelThumbnailsNode = [[ASCacheNetworkImageNode alloc] initForImageCache];

   // configure the button
//   videoCoverThumbnailsNode.userInteractionEnabled = YES; // opt into touch handling
//   [videoCoverThumbnailsNode addTarget:self
//                                  action:@selector(channelThumbnailsTapped:)
//                        forControlEvents:ASControlNodeEventTouchUpInside];


   [self showChannelThumbnail:[YoutubeParser getChannelIdByVideo:self.cardInfo]];

   self.videoChannelThumbnailsNode = videoChannelThumbnailsNode;
}


- (void)showChannelThumbnail:(NSString *)channelId {
   if (self.cardInfo.channelThumbnailUrl) {
      [self.videoChannelThumbnailsNode startFetchImageWithString:self.cardInfo.channelThumbnailUrl];
//      self.videoCoverThumbnailsNode.URL = [NSURL URLWithString:self.cardInfo.channelThumbnailUrl];
      return;
   }

   YoutubeResponseBlock completionBlock = ^(NSArray * array, NSObject * respObject) {
       self.cardInfo.channelThumbnailUrl = respObject;
       [self.videoChannelThumbnailsNode startFetchImageWithString:self.cardInfo.channelThumbnailUrl];
//       self.videoCoverThumbnailsNode.URL = [NSURL URLWithString:respObject];
   };
   [[GYoutubeHelper getInstance] fetchChannelThumbnailsWithChannelId:channelId
                                                          completion:completionBlock
                                                        errorHandler:nil];
}


- (void)didLoad {
   // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
   self.layer.as_allowsHighlightDrawing = YES;

   [super didLoad];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   // called on a background thread.  custom nodes must call -measure: on their subnodes in -calculateSizeThatFits:
   CGSize measuredSize = [_textNode measure:CGSizeMake(constrainedSize.width - 2 * kTextPadding,
    constrainedSize.height - 2 * kTextPadding)];
   return CGSizeMake(constrainedSize.width, measuredSize.height + 2 * kTextPadding);
}


- (void)layout {
   _videoChannelThumbnailsNode.frame = CGRectMake(2, 2, 40, 40);

   // called on the main thread.  we'll use the stashed size from above, instead of blocking on text sizing
   CGSize textNodeSize = _textNode.calculatedSize;
   _textNode.frame = CGRectMake(
    50, kTextPadding, textNodeSize.width, textNodeSize.height);

   CGFloat pixelHeight = 1.0f / [[UIScreen mainScreen] scale];
   _divider.frame = CGRectMake(0.0f, 0.0f, self.calculatedSize.width, pixelHeight);
}


@end
