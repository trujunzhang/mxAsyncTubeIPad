//
//  YoutubeGridLayoutViewController.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <YoutubeCollectionView/IpadGridViewCell.h>
#import "YoutubeGridLayoutViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "KRLCollectionViewGridLayout.h"
#import "YTGridVideoCellNode.h"


@interface YoutubeGridLayoutViewController ()<ASCollectionViewDataSource, ASCollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDelegate>
@property(strong, nonatomic) ASCollectionView * collectionView;
@property(nonatomic, strong) UIImage * placeHolderImage;
@end


@implementation YoutubeGridLayoutViewController

- (void)viewDidLoad {
   [self.view addSubview:[self getCollectionView]];
   self.placeHolderImage = [UIImage imageNamed:@"mt_cell_cover_placeholder"];
   [self setUICollectionView:self.collectionView];

   [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
   [super viewDidAppear:animated];

   [self.nextPageDelegate executeNextPageTask]; // test
}


- (UICollectionView *)getCollectionView {
   if (!self.collectionView) {
      self.layout = [[KRLCollectionViewGridLayout alloc] init];
      self.layout.aspectRatio = 1;
      self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
      self.layout.interitemSpacing = 30;
      self.layout.lineSpacing = 20;
      self.layout.aspectRatio = 1.1;
      self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;


      self.collectionView = [[ASCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
      self.collectionView.asyncDataSource = self;
      self.collectionView.asyncDelegate = self;

      self.collectionView.backgroundColor = [UIColor whiteColor];
   }
   return self.collectionView;
}


#pragma mark - Life Cycle


- (void)dealloc {
   self.collectionView.asyncDataSource = nil;
   self.collectionView.asyncDelegate = nil;
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];
   self.collectionView.frame = self.view.bounds;

   [self updateLayout:[UIApplication sharedApplication].statusBarOrientation];
}


- (void)updateLayout:(UIInterfaceOrientation)orientation {
   self.layout.numberOfItemsPerLine = [(self.numbersPerLineArray[UIInterfaceOrientationIsPortrait(orientation) ? 0 : 1]) intValue];
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   if (section == 0) {
      return [self getYoutubeRequestInfo].videoList.count;
   } else {
      return 1;
   }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   return 2;
}


- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
   ASCellNode * node;

   switch (indexPath.section) {
      case 0:
         node = [self getCellNodeAtIndexPath:indexPath];
         break;
      case 1:
         node = [self getLoadMoreNode];
         [self checkVisible];
         break;
   }


   return node;
}


- (void)checkVisible {
   NSArray * array = [self.collectionView indexPathsForVisibleItems];

   NSString * debug = @"debug";

}


- (ASCellNode *)getLoadMoreNode {
   ASCellNode * node = [[ASCellNode alloc] init];

   // attribute a string
   NSDictionary * attrs = @{
    NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
    NSForegroundColorAttributeName : [UIColor redColor],
   };
   NSAttributedString * string = [[NSAttributedString alloc] initWithString:@"shuffle"
                                                                 attributes:attrs];

   // create the node
   ASTextNode * _shuffleNode = [[ASTextNode alloc] init];
   _shuffleNode.attributedString = string;

   // configure the button
   _shuffleNode.userInteractionEnabled = YES; // opt into touch handling

   // size all the things
   CGSize size = [_shuffleNode measure:CGSizeMake(self.view.bounds.size.width, 140)];
   CGPoint origin = CGPointMake(0, 0);
   _shuffleNode.frame = (CGRect) { origin, size };

   [node addSubnode:_shuffleNode];

//   [self.nextPageDelegate executeNextPageTask];

   return node;
}


- (ASCellNode *)getCellNodeAtIndexPath:(NSIndexPath *)indexPath {

   ASCellNode * node;

   YTSegmentItemType itemType = [self getYoutubeRequestInfo].itemType;

   if (itemType == YTSegmentItemVideo) {
      YTYouTubeVideoCache * video = [[self getYoutubeRequestInfo].videoList objectAtIndex:indexPath.row];
      YTGridVideoCellNode * videoCellNode = [[YTGridVideoCellNode alloc] initWithCellNodeOfSize:[self cellSize]];
      [videoCellNode bind:video
         placeholderImage:self.placeHolderImage
                 delegate:self.delegate];

//      videoCellNode.backgroundColor = [UIColor redColor];

      node = videoCellNode;
   }

   return node;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   for (UICollectionViewCell * cell in [self.collectionView visibleCells]) {
      NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
//      NSLog(@"%@", indexPath);
      if (indexPath.section == 1) {
         [self.nextPageDelegate executeNextPageTask];
         return;
      }
   }
}


@end

