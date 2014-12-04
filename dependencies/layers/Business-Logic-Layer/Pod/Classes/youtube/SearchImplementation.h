//
//  SearchImplementation.h
//  IOSTemplate
//
//  Created by djzhang on 9/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYoutubeHelper.h"
@class GYoutubeAuthUser;


@interface SearchImplementation : NSObject


- (void)fetchAuthUserWithDelegate:(id)delegate;

+ (GYoutubeAuthUser *)shareYoutubeAuthUser;
+ (SearchImplementation *)getInstance;

- (void)searchByQueryWithQueryTerm:(NSString *)queryTerm completionHandler:(YoutubeResponseBlock)responseHandler errorHandler:(ErrorResponseBlock)errorHandler;


- (BOOL)isSignedIn;
@end
