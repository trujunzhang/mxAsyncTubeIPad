//
//  LeftMenuItemTree.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "LeftMenuItemTree.h"


@interface LeftMenuItemTree ()<UITableViewDataSource, UITableViewDelegate>

@end


@implementation LeftMenuItemTree


- (instancetype)initWithTitle:(NSString *)title itemType:(LeftMenuItemTreeType)type rowsArray:(NSArray *)rowsArray hideTitle:(BOOL)hideTitle remoteImage:(BOOL)remoteImage {
   self = [super init];
   if (self) {
      self.title = title;
      self.itemType = type;
      self.rowsArray = rowsArray;
      self.hideTitle = hideTitle;
      self.isRemoteImage = remoteImage;
      self.cellIdentifier = [LeftMenuItemTree cellIdentifierArray][type];
   }

   return self;
}


+ (NSArray *)cellIdentifierArray {
   return @[
    @"CategoriesCellIdentifier",
    @"SignUserCellIdentifier",
    @"SubscriptionsCellIdentifier",
   ];
}


@end
