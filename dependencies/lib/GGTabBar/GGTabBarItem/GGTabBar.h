//
//  VITabBar.h
//  Vinoli
//
//  Created by Nicolas Goles on 6/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGTabBarDelegate;

static const NSInteger kSeparatorOffsetTag = 7000;
static const NSInteger kMarginSeparatorOffsetTag = 8000;


static CGFloat tabBarPadding = 0.0f;
static CGFloat seperatorWidth = 1.0f;


@interface GGTabBar : UIView

@property(nonatomic, strong) NSArray * viewControllers;

@property(nonatomic, strong) id<GGTabBarDelegate> delegate;

@property(nonatomic, strong) UIViewController * selectedViewController;
@property(nonatomic, strong) id selectedButton;

@property(nonatomic) BOOL inTop;

- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers appearance:(NSDictionary *)appearance inTop:(BOOL)inTop selectedIndex:(NSInteger)selectedIndex;

- (void)setAppearance:(NSDictionary *)appearance;
- (void)startDebugMode;

@end


@protocol GGTabBarDelegate<NSObject>
- (void)tabBar:(GGTabBar *)tabBar didPressButton:(id)button atIndex:(NSUInteger)tabIndex;
@end
