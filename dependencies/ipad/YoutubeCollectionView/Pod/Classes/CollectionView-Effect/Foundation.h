//
//  Foundation.h
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"


@interface NSAttributedString (custom)

+ (NSAttributedString *)attributedStringForTitleText:(NSString *)text;
+ (NSAttributedString *)attributedStringForDurationText:(NSString *)text;
+ (NSAttributedString *)attributedStringForChannelTitleText:(NSString *)text;

+ (NSAttributedString *)attributedStringForPageChannelTitleText:(NSString *)text;
+ (NSAttributedString *)attributedStringForChannelStatisticsSubscriberCount:(NSString *)text;

+ (NSAttributedString *)attributedStringForLeftMenuSubscriptionTitleText:(NSString *)text fontSize:(CGFloat)fontSize;

@end


@interface NSParagraphStyle (custom)

+ (NSParagraphStyle *)justifiedParagraphStyle;
+ (NSParagraphStyle *)justifiedParagraphStyleForDuration;
+ (NSMutableParagraphStyle *)justifiedParagraphStyleForTitleText:(UIFont *)font;
+ (NSParagraphStyle *)justifiedParagraphStyleForChannelTitle;
+ (NSParagraphStyle *)justifiedParagraphStyleForPageChannelTitle;

+ (NSParagraphStyle *)justifiedParagraphStyleForLeftMenuSubscriptionTitle;

@end


@interface NSShadow (custom)

+ (NSShadow *)titleTextShadow;
+ (NSShadow *)descriptionTextShadow;
@end


