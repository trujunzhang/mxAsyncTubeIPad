//
//  IpadGridViewInfoCell.h
//  IOSTemplate
//
//  Created by djzhang on 10/23/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoutubeConstants.h"


@interface IpadGridViewInfoCell : UIView

@property(unsafe_unretained, nonatomic) IBOutlet UILabel * titleLaebl;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel * ratingLabel;
@property(unsafe_unretained, nonatomic) IBOutlet UILabel * viewCountLabel;

- (void)bind:(YTYouTubeVideoCache *)video;
@end
