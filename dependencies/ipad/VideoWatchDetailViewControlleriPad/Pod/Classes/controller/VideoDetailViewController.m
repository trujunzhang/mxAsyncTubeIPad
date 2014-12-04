//
//  VideoDetailViewController.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/14/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "VideoDetailViewController.h"

#import "AsyncVideoDetailPanel.h"
#import "AsyncVideoChannelDetailPanel.h"

static const NSInteger kLitterSize = 2;


@interface VideoDetailViewController ()<ASTableViewDataSource, ASTableViewDelegate> {
   ASTableView * _tableView;
}

@end


@implementation VideoDetailViewController


#pragma mark -
#pragma mark UIViewController.


- (instancetype)initWithVideo:(YTYouTubeVideoCache *)video {
   if (!(self = [super init]))
      return nil;
   self.video = video;

   _tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
   _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // KittenNode has its own separator
   _tableView.showsVerticalScrollIndicator = NO;
   _tableView.asyncDataSource = self;
   _tableView.asyncDelegate = self;

   return self;
}


- (void)viewDidLoad {
   [super viewDidLoad];

   [self.view addSubview:_tableView];
}


- (void)viewWillLayoutSubviews {
   _tableView.frame = self.view.bounds;
}


#pragma mark -
#pragma mark Kittens.


- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
   ASCellNode * node;
   // special-case the first row
   if (indexPath.row == 0) {
      node = [[AsyncVideoChannelDetailPanel alloc] initWithVideo:self.video];
   } else if (indexPath.row == 1) {
      node = [[AsyncVideoDetailPanel alloc] initWithVideo:self.video];
   }

   return node;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return kLitterSize;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
   // disable row selection
   return NO;
}


@end
