//
//  IpadGridViewCell.h
//  app
//
//  Created by djzhang on 9/16/14.
//  Copyright (c) 2014 xinma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YoutubeConstants.h"

@class IpadGridViewInfoCell;
@class IpadGridViewUserCell;


@protocol IpadGridViewCellDelegate<NSObject>

@optional

- (void)gridViewCellTap:(YTYouTubeVideoCache *)video;

@end


@interface IpadGridViewCell : UICollectionViewCell

@property(strong, nonatomic) IBOutlet UIImageView * thumbnails;


@property(strong, nonatomic) IBOutlet UIView * infoView;

@property(unsafe_unretained, nonatomic) IBOutlet UIView * userView;

@property(nonatomic, assign) id<IpadGridViewCellDelegate> delegate;
@property(nonatomic, strong) YTYouTubeVideoCache * video;


- (void)bind:(YTYouTubeVideoCache *)video placeholderImage:(UIImage *)image delegate:(id<IpadGridViewCellDelegate>)delegate;
@end
