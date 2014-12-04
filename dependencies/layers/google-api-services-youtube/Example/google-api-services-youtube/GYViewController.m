//
//  GYViewController.m
//  google-api-services-youtube
//
//  Created by wanghaogithub720 on 09/25/2014.
//  Copyright (c) 2014 wanghaogithub720. All rights reserved.
//

#import "GYViewController.h"

#import "GYoutubeHelper.h"



@interface GYViewController ()

@end


@implementation GYViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   // Do any additional setup after loading the view, typically from a nib.

   YoutubeResponseBlock completion = ^(NSArray * array, NSObject * respObject) {
       NSString * debug = @"debug";
   };
   ErrorResponseBlock error = ^(NSError * error) {
       NSString * debug = @"debug";
   };
//   [[GYoutubeHelper getInstance] searchByQueryWithQueryTerm:@"sketch3" completionHandler:completion errorHandler:error];
//   [[GYoutubeHelper getInstance] fetchSubscriptionsListWithVideoId:@"sketch3" completionHandler:completion errorHandler:error];
//   [[GYoutubeHelper getInstance] fetchChannelListWithChannelId:@"UC0wObT_HayGfWLdRAnFyPwA"
//                                                    completion:completion
//                                                  errorHandler:error];
   [self setupUI];
}


- (void)setupUI {
   //1. edit button
   UIButton * editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   editButton.frame = CGRectMake(100, 100, 100, 100);
   [editButton addTarget:self
                  action:@selector(loginInTouch)
        forControlEvents:UIControlEventTouchDown];

   [editButton setTitle:@"login" forState:UIControlStateNormal];

   [self.view addSubview:editButton];

   //2. refreshButton
   UIButton * refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   refreshButton.frame = CGRectMake(300, 100, 100, 100);
   [refreshButton addTarget:self
                     action:@selector(refreshButtonTouch)
           forControlEvents:UIControlEventTouchDown];

   [refreshButton setTitle:@"refreshButton" forState:UIControlStateNormal];

   [self.view addSubview:refreshButton];

   //3. Signing Out
   UIButton * signingOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   signingOutButton.frame = CGRectMake(100, 200, 100, 100);
   [signingOutButton addTarget:self
                        action:@selector(signingOutButtonTouch)
              forControlEvents:UIControlEventTouchDown];

   [signingOutButton setTitle:@"Signing Out" forState:UIControlStateNormal];

   [self.view addSubview:signingOutButton];

   //6user label
   self.label = [[UILabel alloc] init];
   self.label.frame = CGRectMake(100, 500, 300, 100);
   self.label.textColor = [UIColor redColor];
   self.label.text = @"not login";

   [self.view addSubview:self.label];

   [self refreshButtonTouch];
}


- (void)signingOutButtonTouch {
   [[GYoutubeHelper getInstance] signingOut];

   [self refreshButtonTouch];
}


- (void)refreshButtonTouch {
   BOOL isSignedIn = [[GYoutubeHelper getInstance] isSignedIn];
   if (isSignedIn) {
      self.label.text = [[GYoutubeHelper getInstance] getAuthorizer].userEmail;
   }
}


- (void)loginInTouch {
   GTMOAuth2ViewControllerTouch * viewController =
    [[GYoutubeHelper getInstance] getYoutubeOAuth2ViewControllerTouchWithTouchDelegate:self
                                                                       leftBarDelegate:self
                                                                          cancelAction:@selector(cancelGdriveSignIn:)];

   UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
   navigationController.view.backgroundColor = [UIColor whiteColor];

   [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)viewController:(UIViewController *)viewController
      finishedWithAuth:(YTOAuth2Authentication *)auth
                 error:(NSError *)error {
   [self cancelGdriveSignIn:nil];

   if (error != nil) {
      // Authentication failed
      NSLog(@"failed");
   } else {
      // Authentication succeeded
      NSLog(@"Success");

//      [[GYoutubeHelper getInstance] saveAuthorizer:auth];

      [self refreshButtonTouch];
   }
}


- (void)cancelGdriveSignIn:(id)cancelGdriveSignIn {
   [self dismissViewControllerAnimated:YES completion:^(void) {
   }];
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

@end
