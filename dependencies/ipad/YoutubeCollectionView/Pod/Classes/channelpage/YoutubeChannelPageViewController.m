//
//  YoutubeChannelPageViewController.m
//  IOSTemplate
//
//  Created by djzhang on 11/12/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <google-api-services-youtube/GYoutubeHelper.h>
#import "YoutubeChannelPageViewController.h"
#import "YTAsyncYoutubeChannelTopCellNode.h"
#import "GGTabBarController.h"
#import "GGLayoutStringTabBar.h"


@interface YoutubeChannelPageViewController ()<YoutubeCollectionNextPageDelegate, GGTabBarControllerDelegate>

@property(strong, nonatomic) IBOutlet UIView * topBannerContainer;
@property(strong, nonatomic) IBOutlet UIView * tabbarViewsContainer;


@property(nonatomic, strong) NSString * channelId;
@property(nonatomic, strong) YTYouTubeChannel * pageChannel;

@property(nonatomic, strong) YTAsyncYoutubeChannelTopCellNode * topBanner;
@property(nonatomic, strong) GGTabBarController * videoTabBarController;

@property(nonatomic, strong) NSMutableArray * tabBarControllers;

@property(nonatomic, strong) YTCollectionViewController * selectedController;
@property(nonatomic) YTSegmentItemType selectedSegmentItemType;

@end


@implementation YoutubeChannelPageViewController


- (instancetype)initWithChannelId:(NSString *)channelId {
   self = [super init];
   if (self) {
      self.channelId = channelId;

      YoutubeResponseBlock completion = ^(NSArray * array, NSObject * respObject) {
          self.pageChannel = array[0];
          // 1
//          [self makeTopBanner:self.topBannerContainer];
      };
      ErrorResponseBlock error = ^(NSError * error) {
          NSString * debug = @"debug";
      };
      [[GYoutubeHelper getInstance] fetchChannelForPageView:self.channelId completion:completion errorHandler:error];
   }

   return self;
}


- (void)viewDidLoad {
   [super viewDidLoad];

   // Do any additional setup after loading the view from its nib.

   [self makeSegmentTabs:self.tabbarViewsContainer];
   [self fetchListWithController:self.tabBarControllers[0] withType:YTSegmentItemVideo];

   if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
      self.edgesForExtendedLayout = UIRectEdgeNone;
      self.automaticallyAdjustsScrollViewInsets = NO;
   }
}


- (void)makeSegmentTabs:(UIView *)parentView {
   // 1
   self.tabBarControllers = [[NSMutableArray alloc] init];
   for (NSString * title in [GYoutubeRequestInfo getChannelPageSegmentTitlesArray]) {
      YTCollectionViewController * controller = [[YTCollectionViewController alloc] init];
      controller.delegate = self.delegate;
      controller.nextPageDelegate = self;
      controller.title = title;
      controller.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];
      [self.tabBarControllers addObject:controller];
   }

   // 2
   GGTabBar * topTabBar = [[GGLayoutStringTabBar alloc] initWithFrame:CGRectZero
                                                      viewControllers:self.tabBarControllers
                                                           appearance:nil
                                                                inTop:YES
                                                        selectedIndex:0];

   GGTabBarController * tabBarController = [[GGTabBarController alloc] initWithTabBarView:topTabBar];

   tabBarController.view.frame = parentView.bounds;
   tabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

   tabBarController.delegate = self;

   self.videoTabBarController = tabBarController;
   [parentView addSubview:self.videoTabBarController.view];
}


- (void)makeTopBanner:(UIView *)parentView {

   // Create a new private queue
   dispatch_queue_t _backgroundQueue;
   _backgroundQueue = dispatch_queue_create("com.youtube.page.topcell", NULL);

   dispatch_async(_backgroundQueue, ^{

       self.topBanner = [[YTAsyncYoutubeChannelTopCellNode alloc] initWithChannel:self.pageChannel
                                                                         cellSize:parentView.frame.size];
       // self.view isn't a node, so we can only use it on the main thread
       dispatch_sync(dispatch_get_main_queue(), ^{
           self.topBanner.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;// used
           [parentView addSubview:self.topBanner.view];
       });
   });
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

   [self.topBanner layoutNodes:self.topBannerContainer.frame.size];
}


#pragma mark -
#pragma mark GGTabBarControllerDelegate


- (void)ggTabBarController:(GGTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
   if (self.selectedController == viewController)
      return;

   [self fetchListWithController:viewController withType:tabBarController.selectedIndex];
}


- (void)fetchListWithController:(YTCollectionViewController *)controller withType:(YTSegmentItemType)type {
   self.selectedController = controller;
   self.selectedSegmentItemType = type;

   [self executeRefreshTask];
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
   if ([self.selectedController getYoutubeRequestInfo].hasFirstFetch)
      return;

   NSString * channelId = self.channelId;
   switch (self.selectedSegmentItemType) {
      case YTSegmentItemVideo:
         [self.selectedController fetchActivityListByType:self.selectedSegmentItemType
                                            withChannelId:channelId];
         break;
      case YTSegmentItemChannel:
         [self.selectedController fetchVideoListFromChannelWithChannelId:channelId];
         break;
      case YTSegmentItemPlaylist:
         [self.selectedController fetchPlayListFromChannelWithChannelId:channelId];
         break;
   }
}


- (void)executeNextPageTask {
   switch (self.selectedSegmentItemType) {
      case YTSegmentItemVideo:
         [self.selectedController fetchActivityListByPageToken];
         break;
      case YTSegmentItemChannel:
         [self.selectedController fetchVideoListFromChannelByPageToken];
         break;
      case YTSegmentItemPlaylist:
         [self.selectedController fetchPlayListFromChannelByPageToken];
         break;
   }
}


@end
