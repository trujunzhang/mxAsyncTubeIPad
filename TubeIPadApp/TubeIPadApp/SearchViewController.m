//
//  SearchViewController.m
//  TubeIPadApp
//
//  Created by djzhang on 10/23/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//



#import "SearchViewController.h"

#import "VideoDetailViewControlleriPad.h"
#import "YoutubePopUpTableViewController.h"
#import "GYoutubeHelper.h"


@interface SearchViewController ()<IpadGridViewCellDelegate, UISearchBarDelegate, YoutubeCollectionNextPageDelegate, UIPopoverControllerDelegate, YoutubePopUpTableViewDelegate>
@property(strong, nonatomic) UISegmentedControl * segment_title;
@property(nonatomic, strong) UISearchBar * searchBar;
@property(nonatomic, strong) UIBarButtonItem * sarchBarItem;

@property(nonatomic, strong) YoutubePopUpTableViewController * searchAutoCompleteViewController;
@property(nonatomic, strong) UIPopoverController * popover;
@end


@implementation SearchViewController


- (void)viewDidLoad {
   [super viewDidLoad];
   // Do any additional setup after loading the view, typically from a nib.
   self.view.backgroundColor = [UIColor clearColor];

   self.delegate = self;
   self.nextPageDelegate = self;
   self.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];

   self.searchAutoCompleteViewController = [[YoutubePopUpTableViewController alloc] init];
   self.searchAutoCompleteViewController.popupDelegate = self;

   [self setupNavigationRightItem];
   [self setupNavigationTitle];
}


- (void)setupNavigationRightItem {
   self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 220, 19)];
   self.searchBar.backgroundColor = [UIColor clearColor];
   self.searchBar.showsCancelButton = YES;
   self.searchBar.userInteractionEnabled = YES;
   self.searchBar.placeholder = @"Search";

   [self search:@"lightroom" withItemType:YTSegmentItemVideo];// test
//   [self searchByPageToken];// test

   self.searchBar.delegate = self;

   self.sarchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
   self.navigationItem.rightBarButtonItem = self.sarchBarItem;
}


- (void)setupNavigationTitle {
   self.segment_title = [[UISegmentedControl alloc] initWithItems:[GYoutubeRequestInfo getSegmentTitlesArray]];
   self.segment_title.selectedSegmentIndex = 0;
   self.segment_title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
   self.segment_title.frame = CGRectMake(0, 0, 300, 30);
   [self.segment_title addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
   self.segment_title.tintColor = [UIColor redColor];
   self.navigationItem.titleView = self.segment_title;
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - IpadGridViewCellDelegate


- (void)gridViewCellTap:(YTYouTubeVideoCache *)video {
   VideoDetailViewControlleriPad * controller = [[VideoDetailViewControlleriPad alloc] initWithDelegate:self
                                                                                                  video:video];

   [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark -
#pragma mark - UISearchBarDelegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   [self segmentAction:nil];
   [self.searchBar resignFirstResponder];
   if (self.popover != nil) {
      [self.popover dismissPopoverAnimated:YES];
      self.popover = nil;
   }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   if (!self.popover)
      [self popAutoCompletDialog];

   if ([self.searchBar.text isEqualToString:@""]) {
      [self.searchAutoCompleteViewController empty];
      [[GYoutubeHelper getInstance] cancelAutoCompleteSuggestionTask];
      return;
   }

   YoutubeResponseBlock completion = ^(NSArray * array, NSObject * respObject) {
       [self.searchAutoCompleteViewController resetTableSource:array];
   };
   ErrorResponseBlock error = ^(NSError * error) {
       NSString * debug = @"debug";
   };
   [[GYoutubeHelper getInstance] autoCompleteSuggestions:self.searchBar.text
                                       CompletionHandler:completion
                                            errorHandler:error];
}


#pragma mark -
#pragma mark -  UISegmentedControl event


- (void)segmentAction:(id)sender {
   if (self.searchBar.text.length == 0)
      return;

   YTSegmentItemType itemType = [GYoutubeRequestInfo getItemTypeByIndex:self.segment_title.selectedSegmentIndex];
   [self search:self.searchBar.text withItemType:itemType];
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
   [self segmentAction:nil];
}


- (void)executeNextPageTask {
   [self searchByPageToken];
}


#pragma mark -
#pragma mark google autocomplete search suggest


- (void)popAutoCompletDialog {
   self.popover = [[UIPopoverController alloc] initWithContentViewController:self.searchAutoCompleteViewController];
   self.popover.delegate = self;

   [self.popover presentPopoverFromBarButtonItem:self.sarchBarItem
                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                        animated:YES];
}


#pragma mark - Popover Controller Delegate


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
   self.popover = nil;
}


#pragma mark -
#pragma mark YoutubePopUpTableViewDelegate


- (void)didSelectRowWithValue:(NSString *)value {
   self.searchBar.text = value;
   [self searchBarSearchButtonClicked:nil];
}


@end