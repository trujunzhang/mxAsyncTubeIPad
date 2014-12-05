//
//  YTAsChannelThumbnailsImageNode.m
//  IOSTemplate
//
//  Created by djzhang on 10/24/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "YTAsChannelThumbnailsImageNode.h"
#import "YoutubeParser.h"
#import "GYoutubeHelper.h"


@interface YTAsChannelThumbnailsImageNode () {

}

@end


@implementation YTAsChannelThumbnailsImageNode

- (instancetype)initWithChannelId:(NSString *)channelId {
   self = [super init];
   if (self) {
      self.channelId = channelId;

      [self checkCacheAndFetchImage];
   }

   return self;
}


- (void)checkCacheAndFetchImage {
   YoutubeResponseBlock completionBlock = ^(NSArray * array, NSObject * respObject) {
       [self startFetchImageWithString:respObject];
   };
   [[GYoutubeHelper getInstance] fetchChannelThumbnailsWithChannelId:self.channelId
                                                          completion:completionBlock
                                                        errorHandler:nil];
}


+ (instancetype)nodeWithChannelId:(NSString *)channelId {
   NSString * thumbnailUrl = [YoutubeParser checkAndAppendThumbnailWithChannelId:channelId];
   if (thumbnailUrl) {
      return [YTAsChannelThumbnailsImageNode nodeWithImageUrl:thumbnailUrl];
   }

   return [[self alloc] initWithChannelId:channelId];
}


@end
