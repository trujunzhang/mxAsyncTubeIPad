//
//  IpadGridViewCell.m
//  app
//
//  Created by djzhang on 9/16/14.
//  Copyright (c) 2014 xinma. All rights reserved.
//

#import "IpadGridViewCell.h"


#import "IpadGridViewInfoCell.h"
#import "IpadGridViewUserCell.h"

#import "CacheImageConstant.h"


@interface IpadGridViewCell ()

@property(nonatomic, strong) IpadGridViewInfoCell * infoCell;
@property(nonatomic, strong) IpadGridViewUserCell * userCell;
@end


@implementation IpadGridViewCell

- (id)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];

   if (self) {
      // Initialization code
      NSArray * arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"IpadGridViewCell" owner:self options:nil];

      if ([arrayOfViews count] < 1) {
         return nil;
      }

      if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
         return nil;
      }

      self = [arrayOfViews objectAtIndex:0];

      [self setupUI];
   }

   return self;

}


- (void)setupUI {
   // Add other views
   // 1
   self.infoCell = [[[NSBundle mainBundle] loadNibNamed:@"IpadGridViewInfoCell"
                                                  owner:self
                                                options:nil] lastObject];
   self.infoCell.backgroundColor = [UIColor clearColor];
   self.infoCell.frame = CGRectMake(0, 0, self.infoView.frame.size.width, self.infoView.frame.size.height);
   [self.infoView addSubview:self.infoCell];



   //2
   self.userCell = [[[NSBundle mainBundle] loadNibNamed:@"IpadGridViewUserCell"
                                                  owner:self
                                                options:nil] lastObject];
   self.userCell.backgroundColor = [UIColor clearColor];
   self.userCell.frame = CGRectMake(0, 0, self.userView.frame.size.width, self.userView.frame.size.height);
   [self.userView addSubview:self.userCell];


}


- (void)bind:(YTYouTubeVideoCache *)video placeholderImage:(UIImage *)image delegate:(id<IpadGridViewCellDelegate>)delegate {
   self.video = video;
   self.delegate = delegate;

   [self.infoCell bind:video];
   [self.userCell bind:video];

   // Confirm that the result represents a video. Otherwise, the
   // item will not contain a video ID.

   // 1
   [YTCacheImplement CacheWithImageView:self.thumbnails
                                   withUrl:video.snippet.thumbnails.medium.url
                           withPlaceholder:image];
//   NSLog(@"url= %@", video.snippet.thumbnails.standard.url);

   // UIImageView Touch event
   UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapDetected)];
   singleTap.numberOfTapsRequired = 1;
   [self.thumbnails setUserInteractionEnabled:YES];
   [self.thumbnails addGestureRecognizer:singleTap];


   // UIView Touch event
   UITapGestureRecognizer * singleTapPanel = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapDetected)];
   singleTapPanel.numberOfTapsRequired = 1;
   [self.infoView setUserInteractionEnabled:YES];
   [self.infoView addGestureRecognizer:singleTapPanel];
}


- (void)tapDetected {
   NSLog(@"single Tap on imageview");

   if (self.delegate) {
      [self.delegate gridViewCellTap:self.video];
   }
}

@end
