//
//  LeftMenuViewController.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//


#import "LeftMenuViewController.h"

#import "LeftMenuViewBase.h"
#import "STCollapseTableView.h"
#import "GYoutubeAuthUser.h"
#import "LeftMenuItemTree.h"
#import "LeftMenuTableHeaderView.h"
#import "YTLeftRowTableViewCell.h"

static NSString * const leftmenuIdentifier = @"LeftMenuViewIdentifier";


@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) STCollapseTableView * tableView;
@end


@implementation LeftMenuViewController


- (void)setupTableViewExclusiveState {
   [self.tableView setExclusiveSections:NO];
   for (int i = 0; i < [self.tableSectionArray count]; i++) {
      [self.tableView openSection:i animated:NO];
   }
}


- (void)viewDidLoad {
   // 1
   self.tableView = [[STCollapseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];

   self.tableView.dataSource = self;
   self.tableView.delegate = self;


   [self.tableView registerClass:[YTLeftRowTableViewCell class] forCellReuseIdentifier:leftmenuIdentifier];

   [self setCurrentTableView:self.tableView];

   // 2
   [self defaultRefreshForSubscriptionList];

   [super viewDidLoad];
}



#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [self.tableSectionArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   YTLeftRowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:leftmenuIdentifier];
   if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftmenuIdentifier];
   }

   LeftMenuItemTree * menuItemTree = self.tableSectionArray[indexPath.section];
   NSArray * line = menuItemTree.rowsArray[indexPath.row];

   [cell   bind:line[0]
withLineIconUrl:line[1]
  isRemoteImage:menuItemTree.isRemoteImage
             cellSize:CGSizeMake(250, 30)
nodeConstructionQueue:self.nodeConstructionQueue];

   cell.backgroundColor = [UIColor clearColor];

   return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   LeftMenuItemTree * menuItemTree = self.tableSectionArray[section];
   return menuItemTree.rowsArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return 42;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   LeftMenuItemTree * menuItemTree = self.tableSectionArray[section];
   if (menuItemTree.hideTitle) {
      return 0;
   }

   return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   LeftMenuTableHeaderView * header = [self.headers objectAtIndex:section];

   return header;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   NSInteger section = indexPath.section;
   NSInteger row = indexPath.row;

   LeftMenuItemTree * menuItemTree = self.tableSectionArray[section];
   NSArray * line = menuItemTree.rowsArray[row];

   LeftMenuItemTreeType itemType = menuItemTree.itemType;
   switch (itemType) {
      case LMenuTreeUser:
         [self.delegate startToggleLeftMenuWithTitle:line[0] withType:[(line[2]) intValue]];
         break;
      case LMenuTreeSubscriptions: {
         YTYouTubeSubscription * subscription = self.authUser.subscriptions[indexPath.row];
         [self.delegate endToggleLeftMenuEventForChannelPageWithSubscription:subscription withTitle:line[0]];
      }
         break;
      case LMenuTreeCategories: {
      }
   }
}



@end
