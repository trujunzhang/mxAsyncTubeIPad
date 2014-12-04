//
//  SearchImplementation.m
//  IOSTemplate
//
//  Created by djzhang on 9/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "SearchImplementation.h"

#import "GYoutubeAuthUser.h"

SearchImplementation * instance;


@implementation SearchImplementation


+ (SearchImplementation *)getInstance {
   @synchronized (self) {
      if (instance == nil) {
//         NSLog(@"initializing");
         instance = [[self alloc] init];
      }
//      NSLog(@"Address: %p", instance);
   }
   return (instance);
}


+ (GYoutubeAuthUser *)shareYoutubeAuthUser {
   return [GYoutubeHelper getInstance].youtubeAuthUser;
}


//- (void)searchByQueryWithQueryTerm:(NSString *)queryTerm completionHandler:(YoutubeResponseBlock)responseHandler errorHandler:(ErrorResponseBlock)errorHandler {
//   [[GYoutubeHelper getInstance] searchByQueryWithQueryType:nil
//                                                  queryTerm:queryTerm
//                                          completionHandler:responseHandler
//                                               errorHandler:errorHandler];
//}


- (void)fetchAuthUserWithDelegate:(id)delegate {
   [GYoutubeHelper getInstance].delegate = delegate;
//   [[GYoutubeHelper getInstance] searchByQueryWithQueryTerm:queryTerm
//                                          completionHandler:responseHandler
//                                               errorHandler:errorHandler];
}


- (BOOL)isSignedIn {
   return [GYoutubeHelper getInstance].isSignedIn;
}
@end
