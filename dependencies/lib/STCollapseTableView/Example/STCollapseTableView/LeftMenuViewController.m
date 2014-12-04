//
//  LeftMenuViewController.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "LeftMenuViewController.h"

#import "STCollapseTableView.h"


@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) STCollapseTableView * tableView;

@property(nonatomic, strong) NSMutableArray * data;
@property(nonatomic, strong) NSMutableArray * headers;

@end


@implementation LeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   if (self) {
      [self setupViewController];
   }
   return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
   self = [super initWithCoder:aDecoder];
   if (self) {
      [self setupViewController];
   }
   return self;
}


- (void)setupViewController {
   NSArray * colors = @[ [UIColor redColor],
    [UIColor orangeColor],
    [UIColor yellowColor],
    [UIColor greenColor],
    [UIColor blueColor],
    [UIColor purpleColor] ];

   self.data = [[NSMutableArray alloc] init];
   for (int i = 0; i < [colors count]; i++) {
      NSMutableArray * section = [[NSMutableArray alloc] init];
      for (int j = 0; j < 3; j++) {
         [section addObject:[NSString stringWithFormat:@"Cell n°%i %i", i + 1, j]];
      }
      [self.data addObject:section];
   }

   self.headers = [[NSMutableArray alloc] init];
   for (int i = 0; i < [colors count]; i++) {
      UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
      [header setBackgroundColor:[colors objectAtIndex:i]];
      UILabel * number = [[UILabel alloc] initWithFrame:header.frame];
      number.textAlignment = NSTextAlignmentCenter;
      number.textColor = [UIColor blackColor];
      number.text = [NSString stringWithFormat:@"%i", i + 1];
      [header addSubview:number];

      [self.headers addObject:header];
   }
}


- (void)viewDidLoad {
   [super viewDidLoad];

   self.tableView = [[STCollapseTableView alloc] initWithFrame:self.view.frame];
   self.tableView.dataSource = self;
   self.tableView.delegate = self;

   [self.view addSubview:self.tableView];

   self.tableView.tableHeaderView = ({
      UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
      UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
      imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
      imageView.image = [UIImage imageNamed:@"avatar.jpg"];
      imageView.layer.masksToBounds = YES;
      imageView.layer.cornerRadius = 50.0;
      imageView.layer.borderColor = [UIColor whiteColor].CGColor;
      imageView.layer.borderWidth = 3.0f;
      imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
      imageView.layer.shouldRasterize = YES;
      imageView.clipsToBounds = YES;

      UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
      label.text = @"Roman Efimov";
      label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
      label.backgroundColor = [UIColor clearColor];
      label.textColor = [UIColor colorWithRed:62 / 255.0f green:68 / 255.0f blue:75 / 255.0f alpha:1.0f];
      [label sizeToFit];
      label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

      [view addSubview:imageView];
      [view addSubview:label];
      view;
   });

   [self.tableView reloadData];

   [self.tableView setExclusiveSections:NO];

   [self.tableView openSection:0 animated:NO];
   [self.tableView openSection:1 animated:NO];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString * cellIdentifier = @"cell";

   UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

   if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
   }

   NSString * text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
   cell.textLabel.text = text;

   return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [[self.data objectAtIndex:section] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   if (section == 0) {
      return 0;
   }
   return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   return [self.headers objectAtIndex:section];
}

@end
