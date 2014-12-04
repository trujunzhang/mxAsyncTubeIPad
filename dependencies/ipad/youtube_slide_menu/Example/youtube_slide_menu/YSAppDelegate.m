//
//  YSAppDelegate.m
//  youtube_slide_menu
//
//  Created by CocoaPods on 10/26/2014.
//  Copyright (c) 2014 wanghaogithub720. All rights reserved.
//

#import <SWRevealViewController/SWRevealViewController.h>
#import <youtube_slide_menu/FrontViewController.h>
#import "YSAppDelegate.h"
#import "FrontViewController.h"


@implementation YSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   UIWindow * window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   self.window = window;

   //1
   self.mainViewController = [[FrontViewController alloc] init];
   [self setupSlideMenuController:self.mainViewController];

   self.mainViewController.title = @"Subscriptions";
   self.mainViewController.view.backgroundColor = [UIColor redColor];

   //2
   UIViewController * secondController = [[UIViewController alloc] init];
   secondController.title = @"Search";
   secondController.view.backgroundColor = [UIColor orangeColor];
   // 2.1
   UIBarButtonItem * searchButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"wanghao"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(searchYoutube:)];

   secondController.navigationItem.leftBarButtonItem = searchButtonItem;

   //3
   UIViewController * leftViewController = [self getLeftMenuController];

   //4
   UINavigationController * mainNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
   UINavigationController * secondNavigationController = [[UINavigationController alloc] initWithRootViewController:secondController];

   //5
   self.tabBarController = [[UITabBarController alloc] init];
   self.tabBarController.viewControllers = [NSArray arrayWithObjects:mainNavigationController,
                                                                     secondNavigationController, nil];

   //6
   self.revealController = [[SWRevealViewController alloc] initWithRearViewController:leftViewController
                                                                  frontViewController:self.tabBarController];
   self.revealController.delegate = self;

   //7
   self.window.rootViewController = self.revealController;
   [self.window makeKeyAndVisible];
   return YES;
}


- (UIViewController *)getLeftMenuController {
   UIViewController * leftViewController = [[UIViewController alloc] init];
   leftViewController.view.backgroundColor = [UIColor blueColor];

   UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   button.center = CGPointMake(100, 200);
   [button setTitle:@"What to Watch" forState:UIControlStateNormal];
   [button sizeToFit];
   [button addTarget:self action:@selector(button_Tapped:) forControlEvents:UIControlEventTouchUpInside];

   [leftViewController.view addSubview:button];

   return leftViewController;
}


- (void)button_Tapped:(id)sender {
   NSString * debug = @"debug";
   [self.mainViewController search:@"sketch 3"];
}


- (void)searchYoutube:(id)sender {
   CGRect rect = self.tabBarController.view.frame;

   [self.revealController revealToggleAnimated:YES];
}


- (void)setupSlideMenuController:(UIViewController *)controller {
   SWRevealViewController * revealController = [controller revealViewController];


   [revealController panGestureRecognizer];
   [revealController tapGestureRecognizer];

   UIBarButtonItem * revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mt_side_tab_button"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController
                                                                        action:@selector(revealToggle:)];

   controller.navigationItem.leftBarButtonItem = revealButtonItem;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
   // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
   // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -
#pragma mark - SWRevealViewControllerDelegate


// This will be called inside the reveal animation, thus you can use it to place your own code that will be animated in sync
- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position {
   if (position == FrontViewPositionRight) {
      NSString * debug = @"debug";
   } else if (position == FrontViewPositionLeft) {
      NSString * debug = @"debug";
   }

   NSString * debug = @"debug";
}


@end
