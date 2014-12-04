//
//  LeftMenuViewBase.h
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYoutubeRequestInfo.h"

@class GYoutubeAuthUser;
@class YoutubeAuthInfo;
@class LeftMenuItemTree;


@protocol LeftMenuViewBaseDelegate<NSObject>
@optional
- (void)startToggleLeftMenuWithTitle:(NSString *)title withType:(YTPlaylistItemsType)playlistItemsType;
- (void)endToggleLeftMenuEventForChannelPageWithSubscription:(YTYouTubeSubscription *)subscription withTitle:(id)title;
@end


@interface LeftMenuViewBase : UIViewController

@property(nonatomic, strong) GYoutubeAuthUser * authUser;
@property(nonatomic, strong) UIImage * placeholderImage;
@property(nonatomic, strong) NSArray * tableSectionArray;

@property(nonatomic, strong) NSMutableArray * headers;

- (void)setCurrentTableView:(UITableView *)tableView;
- (void)setupSlideTableViewWithAuthInfo:(YoutubeAuthInfo *)user;
- (void)setupViewController:(NSArray *)subscriptionsArray;
- (UIView *)getUserHeaderView:(YoutubeAuthInfo *)user;

- (void)bind:(UITableViewCell *)cell atSection:(NSInteger)section atRow:(NSInteger)row;

- (NSArray *)defaultCategories;
- (NSArray *)signUserCategories;

@property(nonatomic, assign) id<LeftMenuViewBaseDelegate> delegate;


- (void)defaultRefreshForSubscriptionList;
- (void)refreshChannelSubscriptionList:(GYoutubeAuthUser *)user;
- (void)refreshChannelInfo:(YoutubeAuthInfo *)info;
- (void)setupTableViewExclusiveState;

@end
