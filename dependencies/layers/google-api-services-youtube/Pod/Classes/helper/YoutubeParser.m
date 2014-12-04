//
//  YoutubeParser.m
//  IOSTemplate
//
//  Created by djzhang on 11/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "MABYT3_APIRequest.h"
#import "YoutubeParser.h"


NSMutableDictionary * channelIdThumbnailDictionary;


@interface YoutubeParser ()

@end


@implementation YoutubeParser

+ (NSMutableDictionary *)getChannelIdThumbnailDictionary {
   if (channelIdThumbnailDictionary == nil) {
      channelIdThumbnailDictionary = [[NSMutableDictionary alloc] init];
   }
   return channelIdThumbnailDictionary;
}


+ (NSString *)getVideoIdsByActivityList:searchResultList {
   NSMutableArray * videoIds = [[NSMutableArray alloc] init];
   for (YTYouTubeActivity * searchResult in searchResultList) {
      NSString * videoId = [YoutubeParser getvideoIdByActivity:searchResult.contentDetails];
      if (videoId)
         [videoIds addObject:videoId];
   }
   return [videoIds componentsJoinedByString:@","];
}


+ (NSString *)getvideoIdByActivity:(YTYouTubeActivityContentDetails *)contentDetails {

   NSArray * resourceArray = [NSArray arrayWithObjects:
    contentDetails.upload,
    contentDetails.like,
    contentDetails.favorite,
     nil];


   for (YTYouTubeResourceId * resourceId in resourceArray) {
      if (![resourceId.videoId isEqualToString:@""])
         return resourceId.videoId;
   }

   return nil;
}


+ (NSString *)getVideoIdsBySearchResult:(NSMutableArray *)searchResultList {
   NSMutableArray * videoIds = [[NSMutableArray alloc] init];
   for (YTYouTubeSearchResult * searchResult in searchResultList) {
      [videoIds addObject:searchResult.identifier.videoId];
   }
   return [videoIds componentsJoinedByString:@","];
}


#pragma mark -
#pragma mark Subscription


+ (NSString *)getChannelIdBySubscription:(YTYouTubeSubscription *)subscription {
   return subscription.snippet.resourceId.JSON[@"channelId"];
}


+ (NSString *)getSubscriptionSnippetThumbnailUrl:(YTYouTubeSubscription *)subscription {
   return subscription.snippet.thumbnails.high.url;
}


#pragma mark -
#pragma mark  Video cache


+ (NSString *)getVideoSnippetThumbnails:(YTYouTubeVideoCache *)video {
   return video.snippet.thumbnails.medium.url;
}


+ (NSString *)getWatchVideoId:(YTYouTubeVideoCache *)video {
   return video.identifier;
}


+ (NSString *)getChannelIdByVideo:(YTYouTubeVideoCache *)video {
   return video.snippet.channelId;
}


+ (NSString *)getVideoSnippetTitle:(YTYouTubeVideoCache *)video {
   return video.snippet.title;
}


+ (NSString *)getVideoDurationForVideoInfo:(YTYouTubeVideoCache *)video {
   NSString * durationString = [YoutubeParser parseISO8601Duration:video.contentDetails.duration];
   return [NSString stringWithFormat:@" %@ ", durationString];
}


#pragma mark -
#pragma mark Channel for other request


+ (NSString *)getChannelBannerImageUrl:(YTYouTubeChannel *)channel {
   return channel.brandingSettings.image.bannerMobileHdImageUrl;;
}


+ (NSString *)GetChannelSnippetThumbnail:(YTYouTubeChannel *)channel {
   YTYouTubeMABThumbmail * thumbnail = channel.snippet.thumbnails[@"default"];
   return thumbnail.url;
}


#pragma mark -
#pragma mark Channel for author


+ (NSString *)getAuthChannelSnippetThumbnailUrl:(YTYouTubeAuthorChannel *)channel {
   return channel.snippet.thumbnails.high.url;
}


+ (NSString *)getAuthChannelTitle:(YTYouTubeAuthorChannel *)channel {
   return channel.snippet.title;
}


+ (NSString *)getAuthChannelID:(YTYouTubeAuthorChannel *)channel {
   return channel.identifier;
}


+ (NSString *)checkAndAppendThumbnailWithChannelId:(NSString *)channelId {
   NSMutableDictionary * dictionary = [YoutubeParser getChannelIdThumbnailDictionary];
   NSString * value = [dictionary objectForKey:channelId];
   if (value) {
      return value;
   }
//   else {
//      [dictionary setValue:nil forKey:keyWithChannelId];
//   }
   return nil;
}


+ (void)AppendThumbnailWithChannelId:(NSString *)channelId withThumbnailUrl:(NSString *)thumbnailUrl {
   NSMutableDictionary * dictionary = [YoutubeParser getChannelIdThumbnailDictionary];
   [dictionary setValue:thumbnailUrl forKey:channelId];
}


+ (NSError *)getError:(NSData *)data httpresp:(NSHTTPURLResponse *)httpresp {
   NSError * error;
   NSError * e = nil;
   NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&e];
   if ([dict objectForKey:@"error"]) {
      NSDictionary * dict2 = [dict objectForKey:@"error"];
      if ([dict2 objectForKey:@"errors"]) {
         NSArray * items = [dict2 objectForKey:@"errors"];
         if (items.count > 0) {
            NSString * dom = @"YTAPI";
            if ([items[0] objectForKey:@"domain"]) {
               dom = [items[0] objectForKey:@"domain"];
            }
            error = [NSError errorWithDomain:dom
                                        code:httpresp.statusCode
                                    userInfo:items[0]];
         }
      }
   }
   return error;
}


+ (NSString *)parseISO8601Duration:(NSString *)duration {
//   NSString * duration = @"P1DT10H15M49S";

   int i = 0, days = 0, hours = 0, minutes = 0, seconds = 0;

   while (i < duration.length) {
      NSString * str = [duration substringWithRange:NSMakeRange(i, duration.length - i)];

      i++;

      if ([str hasPrefix:@"P"] || [str hasPrefix:@"T"])
         continue;

      NSScanner * sc = [NSScanner scannerWithString:str];
      int value = 0;

      if ([sc scanInt:&value]) {
         i += [sc scanLocation] - 1;

         str = [duration substringWithRange:NSMakeRange(i, duration.length - i)];

         i++;

         if ([str hasPrefix:@"D"])
            days = value;
         else if ([str hasPrefix:@"H"])
            hours = value;
         else if ([str hasPrefix:@"M"])
            minutes = value;
         else if ([str hasPrefix:@"S"])
            seconds = value;
      }
   }

   if (hours == 0) {
      return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
   }
   return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}


@end
