//
//  YoutubeParser.h
//  IOSTemplate
//
//  Created by djzhang on 11/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YoutubeConstants.h"


@interface YoutubeParser : NSObject

+ (NSString *)getVideoIdsByActivityList:searchResultList;
+ (NSString *)getVideoIdsBySearchResult:(NSMutableArray *)searchResultList;

+ (NSString *)checkAndAppendThumbnailWithChannelId:(NSString *)channelId;
+ (void)AppendThumbnailWithChannelId:(NSString *)channelId withThumbnailUrl:(NSString *)thumbnailUrl;
+ (NSString *)timeFormatConvertToSecondsWithInteger:(NSUInteger)timeSecs;
+ (NSString *)timeFormatConvertToSeconds:(NSString *)timeSecs;

+ (NSError *)getError:(NSData *)data httpresp:(NSHTTPURLResponse *)httpresp;

// Channel for author
+ (NSString *)getAuthChannelSnippetThumbnailUrl:(YTYouTubeAuthorChannel *)channel;
+ (NSString *)getAuthChannelTitle:(YTYouTubeAuthorChannel *)channel;
+ (NSString *)getAuthChannelID:(YTYouTubeAuthorChannel *)channel;


// Channel for other request
+ (NSString *)getChannelBannerImageUrl:(YTYouTubeChannel *)channel;
+ (NSString *)GetChannelSnippetThumbnail:(YTYouTubeChannel *)channel;

// Subscription
+ (NSString *)getChannelIdBySubscription:(YTYouTubeSubscription *)subscription;
+ (NSString *)getSubscriptionSnippetThumbnailUrl:(YTYouTubeSubscription *)subscription;

// Video cache
+ (NSString *)getVideoSnippetThumbnails:(YTYouTubeVideoCache *)video;
+ (NSString *)getWatchVideoId:(YTYouTubeVideoCache *)video;
+ (NSString *)getChannelIdByVideo:(YTYouTubeVideoCache *)video;
+ (NSString *)getVideoSnippetTitle:(YTYouTubeVideoCache *)video;
+ (NSString *)getVideoDurationForVideoInfo:(YTYouTubeVideoCache *)video;


@end
