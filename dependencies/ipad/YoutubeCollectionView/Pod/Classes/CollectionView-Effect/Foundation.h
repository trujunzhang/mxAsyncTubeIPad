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

+ (NSAttributedString *)attributedStringForLeftMenuSubscriptionTitleText:(NSString *)text;

@end


@interface NSParagraphStyle (custom)

+ (NSParagraphStyle *)justifiedParagraphStyle;
+ (NSParagraphStyle *)justifiedParagraphStyleForDuration;
+ (NSMutableParagraphStyle *)justifiedParagraphStyleForTitleText:(UIFont *)font;
+ (NSParagraphStyle *)justifiedParagraphStyleForChannelTitle;

+ (NSParagraphStyle *)justifiedParagraphStyleForLeftMenuSubscriptionTitle;

@end


@interface NSShadow (custom)

+ (NSShadow *)titleTextShadow;
+ (NSShadow *)descriptionTextShadow;
@end


