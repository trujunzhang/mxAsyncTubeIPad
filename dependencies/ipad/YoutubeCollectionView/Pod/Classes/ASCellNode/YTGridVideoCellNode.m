//
//  YTGridVideoCellNode.m
//  IOSTemplate
//
//  Created by djzhang on 11/17/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <YoutubeCollectionView/IpadGridViewCell.h>
#import "YTGridVideoCellNode.h"
#import "YoutubeParser.h"
#import "GYoutubeHelper.h"
#import "CacheImageConstant.h"


CGFloat thumbnailHeight = 142;


@interface YTGridVideoCellNode () {
   CGSize _kittenSize;

   ASImageNode * _imageNode;

   ASDisplayNode * _infoContainerNode;

   ASImageNode * _channelImageNode;
   ASTextNode * _videoTitleNode;
   ASTextNode * _channelTitleNode;
}
@end


@implementation YTGridVideoCellNode


- (instancetype)initWithCellNodeOfSize:(CGSize)size { //242,242
   if (!(self = [super init]))
      return nil;

   _kittenSize = size;

   [self setupUI];

   return self;
}


- (void)setupUI {
   // 1
   _imageNode = [[ASImageNode alloc] init];
   _imageNode.backgroundColor = [UIColor clearColor];
   [self addSubnode:_imageNode];

   // 2
   _infoContainerNode = [[ASDisplayNode alloc] init];
   _infoContainerNode.backgroundColor = [UIColor clearColor];
   [self addSubnode:_infoContainerNode];

   // 2.1
   _channelImageNode = [[ASImageNode alloc] init];
   [_infoContainerNode addSubnode:_channelImageNode];

   // 2.2
   _videoTitleNode = [[ASTextNode alloc] init];
   [_infoContainerNode addSubnode:_videoTitleNode];

   // 2.3
   _channelTitleNode = [[ASTextNode alloc] init];
   [_infoContainerNode addSubnode:_channelTitleNode];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return _kittenSize;
}


- (NSDictionary *)textStyleForVideoTitle {
   NSString * fontName = @"HelveticaNeue";
//   fontName = @"ChalkboardSE-Regular";
   UIFont * font = [UIFont fontWithName:fontName size:14.0f];

   NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
   style.paragraphSpacing = 0.5 * font.lineHeight;
   style.hyphenationFactor = 1.0;
//   style.lineBreakMode = NSLineBreakByTruncatingTail;


   return @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
}


- (NSDictionary *)textStyleForChannelTitle {
   UIFont * font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];

   NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
   style.paragraphSpacing = 0.5 * font.lineHeight;
   style.hyphenationFactor = 1.0;
   style.lineBreakMode = NSLineBreakByTruncatingTail;

   return @{
    NSFontAttributeName : font,
    NSParagraphStyleAttributeName : style,
    NSForegroundColorAttributeName : [UIColor lightGrayColor]
   };
}


- (void)layout {
   // 1
   _imageNode.frame = CGRectMake(0, 0, _kittenSize.width, thumbnailHeight);

   // 2
   CGFloat infoContainerHeight = _kittenSize.height - thumbnailHeight;
   _infoContainerNode.frame = CGRectMake(0, thumbnailHeight + 8, _kittenSize.width, infoContainerHeight - 4);

   // 2.1
   CGFloat titleLeftX = 28;
   _channelImageNode.frame = CGRectMake(0, 3, titleLeftX - 8, titleLeftX - 4);
   CGFloat titleWidth = _kittenSize.width - titleLeftX;
   _videoTitleNode.frame = CGRectMake(titleLeftX, 0, titleWidth, 36);
   _channelTitleNode.frame = CGRectMake(titleLeftX, 36, titleWidth, 32);
}


- (void)bind:(YTYouTubeVideoCache *)video placeholderImage:(UIImage *)placeholder delegate:(id<IpadGridViewCellDelegate>)delegate {
   self.video = video;
   self.delegate = delegate;

   // 1
   NSString * videoThumbnailsUrl = [YoutubeParser getVideoSnippetThumbnails:video];
   NSString * videoTitleValue = video.snippet.title;
   NSString * channelTitleValue = video.snippet.channelTitle;

//   if (video.hasImage) {
//      _imageNode.image = video.image;
//   } else {
//      void (^downloadCompletion)(UIImage *) = ^(UIImage * image) {
//          video.hasImage = YES;
//          video.image = image;
//          _imageNode.image = video.image;
//      };
//      [YTCacheImplement CacheWithImageView:_imageNode
//                                       key:video.identifier
//                                   withUrl:videoThumbnailsUrl
//                           withPlaceholder:placeholder
//                                completion:downloadCompletion
//      ];
//   }


   // configure the button
   _imageNode.userInteractionEnabled = YES; // opt into touch handling
   [_imageNode addTarget:self
                  action:@selector(buttonTapped:)
        forControlEvents:ASControlNodeEventTouchUpInside];

   // 2.1
   [self showChannelThumbnail:[YoutubeParser getChannelIdByVideo:video]];

   // 2.2
   _videoTitleNode.attributedString = [[NSAttributedString alloc] initWithString:videoTitleValue
                                                                      attributes:[self textStyleForVideoTitle]];

   _channelTitleNode.attributedString = [[NSAttributedString alloc] initWithString:channelTitleValue
                                                                        attributes:[self textStyleForChannelTitle]];
}


- (void)showChannelThumbnail:(NSString *)channelId {
   YoutubeResponseBlock completionBlock = ^(NSArray * array, NSObject * respObject) {
       [YTCacheImplement CacheWithImageView:_channelImageNode
                                    withUrl:respObject
                            withPlaceholder:nil
       ];
   };
   NSString * responseUrl = [[GYoutubeHelper getInstance] fetchChannelThumbnailsWithChannelId:channelId
                                                                                   completion:completionBlock
                                                                                 errorHandler:nil];
   if (responseUrl) {
      [YTCacheImplement CacheWithImageView:_channelImageNode
                                   withUrl:responseUrl
                           withPlaceholder:nil
      ];
   }

}


- (void)buttonTapped:(id)buttonTapped {
   if (self.delegate)
      [self.delegate gridViewCellTap:self.video];
}

@end
