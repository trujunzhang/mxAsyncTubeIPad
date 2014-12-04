//
//  JMImageCacheImplement.m
//  IOSTemplate
//
//  Created by djzhang on 10/24/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "JMImageCacheImplement.h"

#import "JMImageCache.h"
#import "UIImage+Resize.h"


@implementation JMImageCacheImplement


+ (UIImage *)getCacheImageWithURL:(NSURL *)url {
   return [[JMImageCache sharedCache] cachedImageForURL:url];
}


+ (id)CacheWithUrl:(NSURL *)url withCompletionBlock:(void (^)(UIImage *))completionBlock {
   [[JMImageCache sharedCache] imageForURL:url completionBlock:completionBlock];

   return nil;
}


+ (void)cancelDowning:(id)operation {
}


+ (void)CacheWithImageView:(UIImageView *)view withUrl:(NSString *)url withPlaceholder:(UIImage *)placeHolder {
   [JMImageCacheImplement CacheWithImageView:view
                                     withUrl:url
                             withPlaceholder:placeHolder
                                        size:CGSizeZero];
}


+ (void)CacheWithImageView:(UIImageView *)view withUrl:(NSString *)url withPlaceholder:(UIImage *)placeHolder size:(CGSize)size {
   view.image = placeHolder;

   [JMImageCacheImplement CacheWithUrl:[NSURL URLWithString:url] withCompletionBlock:^(UIImage * downloadedImage) {
       if (CGSizeEqualToSize(size, CGSizeZero)) {
          view.image = downloadedImage;
       } else {
          view.image = [downloadedImage resizedImageToSize:size];
       }
   }];
}


+ (void)removeAllObjects {
   [[JMImageCache sharedCache] removeAllObjects];
}


@end
