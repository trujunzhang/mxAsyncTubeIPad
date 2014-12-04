//
//  LeftMenuViewBase.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import <Business-Logic-Layer/YoutubeAuthInfo.h>
#import <google-api-services-youtube/GYoutubeHelper.h>
#import "LeftMenuViewBase.h"
#import "UserInfoView.h"
#import "LeftMenuItemTree.h"
#import "LeftMenuTableHeaderView.h"
#import "YoutubeAuthDataStore.h"
#import "GYoutubeAuthUser.h"

static const int TABLE_WIDTH = 258;


@interface LeftMenuViewBase ()<UITableViewDataSource, UITableViewDelegate, UserInfoViewSigningOutDelegate, UIAlertViewDelegate>
@property(nonatomic, strong) UITableView * baseTableView;
@property(nonatomic, strong) ASImageNode * imageNode;

@end


@implementation LeftMenuViewBase


- (void)viewDidLoad {
   [super viewDidLoad];

   [self setupBackground];
   self.placeholderImage = [self imageWithColor:[UIColor clearColor]];

   NSAssert(self.baseTableView, @"not found uitableview instance!");

   [self.view addSubview:_imageNode.view];
   [self.view addSubview:self.baseTableView];
}


- (void)setupBackground {
   _imageNode = [[ASImageNode alloc] init];
   _imageNode.backgroundColor = [UIColor lightGrayColor];
   _imageNode.image = [UIImage imageNamed:@"mt_side_menu_bg"];
}


- (void)setCurrentTableView:(UITableView *)tableView {
   self.baseTableView = tableView;

   self.baseTableView.backgroundColor = [UIColor clearColor];
   self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.baseTableView.showsVerticalScrollIndicator = NO;
   self.baseTableView.autoresizesSubviews = YES;
   self.baseTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}


- (void)viewWillLayoutSubviews {
   CGRect rect = self.view.bounds;
   rect.size.width = TABLE_WIDTH;
   self.baseTableView.frame = rect;
   _imageNode.frame = rect;
}


#pragma mark -
#pragma mark setup


- (void)setupSlideTableViewWithAuthInfo:(YoutubeAuthInfo *)user {
   if (user == nil)
      user = [[[YoutubeAuthDataStore alloc] init] readAuthUserInfo];

   self.baseTableView.tableHeaderView = [self getUserHeaderView:user];
}


- (void)setupViewController:(NSArray *)subscriptionsArray {
   LeftMenuItemTree * defaultMenuItemTree =
    [[LeftMenuItemTree alloc] initWithTitle:@"  Categories"
                                   itemType:LMenuTreeCategories
                                  rowsArray:[self defaultCategories]
                                  hideTitle:NO
                                remoteImage:NO];


   self.tableSectionArray = @[ defaultMenuItemTree ];
   if ([[GYoutubeHelper getInstance] isSignedIn]) {
      LeftMenuItemTree * signUserMenuItemTree =
       [[LeftMenuItemTree alloc] initWithTitle:@"  "
                                      itemType:LMenuTreeUser
                                     rowsArray:[self signUserCategories]
                                     hideTitle:YES
                                   remoteImage:NO];
      LeftMenuItemTree * subscriptionsMenuItemTree =
       [[LeftMenuItemTree alloc] initWithTitle:@"  Subscriptions"
                                      itemType:LMenuTreeSubscriptions
                                     rowsArray:subscriptionsArray
                                     hideTitle:NO
                                   remoteImage:YES];
      self.tableSectionArray = @[ signUserMenuItemTree, subscriptionsMenuItemTree, defaultMenuItemTree ];
//      self.tableSectionArray = @[ subscriptionsMenuItemTree, defaultMenuItemTree ];
   }


   self.headers = [[NSMutableArray alloc] init];

   for (int i = 0; i < [self.tableSectionArray count]; i++) {
      LeftMenuItemTree * menuItemTree = self.tableSectionArray[i];

      LeftMenuTableHeaderView * header = [[[NSBundle mainBundle] loadNibNamed:@"LeftMenuTableHeaderView"
                                                                        owner:nil
                                                                      options:nil] lastObject];
      [header setupUI:menuItemTree.title];
      [self.headers addObject:header];
   }

}


#pragma mark -
#pragma mark Youtube auth login events


- (UIView *)getUserHeaderView:(YoutubeAuthInfo *)user {

   UIView * headerView = nil;
   if ([[GYoutubeHelper getInstance] isSignedIn]) {
      UserInfoView * userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoView"
                                                                   owner:nil
                                                                 options:nil] lastObject];
      userInfoView.delegate = self;
      headerView = [userInfoView bind:user];
   } else {
      headerView = [[[NSBundle mainBundle] loadNibNamed:@"UserLoginView" owner:nil options:nil] lastObject];

      //The setup code (in viewDidLoad in your view controller)
      UITapGestureRecognizer * singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(handleSingleTap:)];
      [headerView addGestureRecognizer:singleFingerTap];
   }

   headerView.frame = CGRectMake(0, 0, 256, 70);

   return headerView;
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
   [self loginInTouch];
}


- (void)loginInTouch {
   GTMOAuth2ViewControllerTouch * viewController =
    [[GYoutubeHelper getInstance] getYoutubeOAuth2ViewControllerTouchWithTouchDelegate:self
                                                                       leftBarDelegate:self
                                                                          cancelAction:@selector(cancelGdriveSignIn:)];

   UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
   navigationController.view.backgroundColor = [UIColor whiteColor];
   navigationController.modalPresentationStyle = UIModalPresentationPageSheet;

   [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)viewController:(UIViewController *)viewController
      finishedWithAuth:(YTOAuth2Authentication *)auth
                 error:(NSError *)error {
   [self cancelGdriveSignIn:nil];

   if (error != nil) {
      // Authentication failed
      NSLog(@"failed");
   } else {
      // Authentication succeeded
      NSLog(@"Success");

      [[GYoutubeHelper getInstance] saveAuthorizeAndFetchUserInfo:auth];
   }
}


- (void)cancelGdriveSignIn:(id)cancelGdriveSignIn {
   [self dismissViewControllerAnimated:YES completion:^(void) {
   }];
}


#pragma mark -
#pragma mark Async refresh Table View


- (void)defaultRefreshForSubscriptionList {
   [self refreshChannelSubscriptionList:[[GYoutubeAuthUser alloc] init]];
}


- (void)refreshChannelSubscriptionList:(GYoutubeAuthUser *)user {
   self.authUser = user;
   // 1
   [self setupViewController:[user getTableRows]];
   [self setupSlideTableViewWithAuthInfo:nil];

   // 2
   [self.baseTableView reloadData];

   //3
   [self setupTableViewExclusiveState];

   // test
   if (debugLeftMenuTapSubscription) {
      if (self.authUser.subscriptions.count >= subscriptionIndex) {
         YTYouTubeSubscription * subscription = self.authUser.subscriptions[subscriptionIndex];
         [self.delegate endToggleLeftMenuEventForChannelPageWithSubscription:subscription
                                                                   withTitle:subscription.snippet.title];
      }
   }
}


- (void)refreshChannelInfo:(YoutubeAuthInfo *)info {
   [self setupSlideTableViewWithAuthInfo:info];
}


#pragma mark -
#pragma mark cell


- (UIImage *)imageWithColor:(UIColor *)color {
   CGRect rect = CGRectMake(0, 0, 32, 32);
   // Create a 1 by 1 pixel context
   UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
   [color setFill];
   UIRectFill(rect);   // Fill it with your color
   UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();

   return image;
}


#pragma mark -
#pragma mark View methods


- (NSArray *)defaultCategories {
   NSArray * array = @[
    @[ @"Autos & Vehicles", @"Autos", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Comedy", @"Comedy", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Education", @"Education", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Entertainment", @"Entertainment", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"File & Animation", @"Film", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Gaming", @"Games", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Howto & Style", @"Howto", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Music", @"Music", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"News & Politics", @"News", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Nonprofits & Activism", @"Nonprofit", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"People & Blogs", @"People", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Pets & Animals", @"Animals", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Science & Technology", @"Tech", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Sports", @"Sports", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Travel & Events", @"Travel", [[NSNumber alloc] initWithInt:kUploadsTag] ],
   ];

   return array;
}


- (NSArray *)signUserCategories {
   NSArray * array = @[
    @[ @"Subscriptions", @"subscriptions",
     [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"What to Watch", @"recommended",
     [[NSNumber alloc] initWithInt:kWatchHistoryTag] ],
    @[ @"Favorite", @"favorites",
     [[NSNumber alloc] initWithInt:kFavoritesTag] ],
    @[ @"Watch Later", @"watch_later",
     [[NSNumber alloc] initWithInt:kWatchLaterTag] ],
    @[ @"Playlists", @"playlists",
     [[NSNumber alloc] initWithInt:kUploadsTag] ],
   ];

   return array;
}


#pragma mark -
#pragma mark UserInfoViewSigningOutDelegate


- (void)signingOutTapped {
   UIAlertView * myAlert = [[UIAlertView alloc]
    initWithTitle:@"Title"
          message:@"Message"
         delegate:self
cancelButtonTitle:@"Cancel"
otherButtonTitles:@"Ok", nil];

   [myAlert show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
   if (buttonIndex == 0) {
   }
   else if (buttonIndex == 1) {
      [[GYoutubeHelper getInstance] signingOut];
      [self defaultRefreshForSubscriptionList];
   }
}


@end
