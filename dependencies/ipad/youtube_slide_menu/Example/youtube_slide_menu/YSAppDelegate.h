//
//  YSAppDelegate.h
//  youtube_slide_menu
//
//  Created by CocoaPods on 10/26/2014.
//  Copyright (c) 2014 wanghaogithub720. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
@class SWRevealViewController;
@class FrontViewController;


@interface YSAppDelegate : UIResponder<UIApplicationDelegate, SWRevealViewControllerDelegate>

@property(strong, nonatomic) UIWindow * window;

@property(nonatomic, strong) SWRevealViewController * revealController;
@property(nonatomic, strong) UITabBarController * tabBarController;
@property(nonatomic, strong) FrontViewController * mainViewController;
@end
