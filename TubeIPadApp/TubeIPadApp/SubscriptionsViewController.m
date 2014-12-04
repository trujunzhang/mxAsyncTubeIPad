//
//  SubscriptionsViewController.m
//  TubeIPadApp
//
//  Created by djzhang on 10/23/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "SubscriptionsViewController.h"

#import "VideoDetailViewControlleriPad.h"

#import "LeftRevealHelper.h"
#import "YoutubeChannelPageViewController.h"


@interface SubscriptionsViewController ()<IpadGridViewCellDelegate, YoutubeCollectionNextPageDelegate>

@property(nonatomic, strong) YTCollectionViewController * youtubeGridLayoutViewController;

@property(nonatomic, assign) YTPlaylistItemsType playlistItemsType;
@end


@implementation SubscriptionsViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   // 1
   // Do any additional setup after loading the view, typically from a nib.
   self.tabBarItem.title = @"Subscriptions";
   self.view.backgroundColor = [UIColor clearColor];
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
   [super viewDidAppear:animated];

}


#pragma mark -
#pragma mark  IpadGridViewCellDelegate


- (void)gridViewCellTap:(YTYouTubeVideoCache *)video {
   [[LeftRevealHelper sharedLeftRevealHelper] closeLeftMenuAndNoRearOpen];

   VideoDetailViewControlleriPad * controller = [[VideoDetailViewControlleriPad alloc] initWithDelegate:self
                                                                                                  video:video];
   [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"back"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:nil
                                                                             action:nil]];
   [self pushViewController:controller animated:YES];
}


#pragma mark -
#pragma mark Left menu events


- (void)startToggleLeftMenuWithTitle:(NSString *)title withType:(YTPlaylistItemsType)playlistItemsType {
   // 1
   self.youtubeGridLayoutViewController = [[YTCollectionViewController alloc] init];
   self.youtubeGridLayoutViewController.title = title;
   self.youtubeGridLayoutViewController.delegate = self;
   self.youtubeGridLayoutViewController.nextPageDelegate = self;
   self.youtubeGridLayoutViewController.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];

   // 2
   self.youtubeGridLayoutViewController.navigationItem.leftBarButtonItem = self.revealButtonItem;
   self.viewControllers = [NSArray arrayWithObject:self.youtubeGridLayoutViewController];

   // 3
   self.playlistItemsType = playlistItemsType;
   [self.youtubeGridLayoutViewController fetchPlayListByType:playlistItemsType];
}


- (void)endToggleLeftMenuEventForChannelPageWithSubscription:(GTLYouTubeSubscription *)subscription withTitle:(NSString *)title {
   // 1
   YoutubeChannelPageViewController * controller = [[YoutubeChannelPageViewController alloc] initWithSubscription:subscription];
   controller.navigationItem.leftBarButtonItem = self.revealButtonItem;
   controller.title = title;
   controller.delegate = self;

   // 2
   self.viewControllers = [NSArray arrayWithObject:controller];
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
   [self.youtubeGridLayoutViewController fetchPlayListByType:self.playlistItemsType];
}


- (void)executeNextPageTask {
   [self.youtubeGridLayoutViewController fetchPlayListByPageToken];
}


@end
