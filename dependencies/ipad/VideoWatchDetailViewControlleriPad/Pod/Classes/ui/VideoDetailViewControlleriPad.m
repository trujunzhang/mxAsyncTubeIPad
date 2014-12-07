#import "VideoDetailViewControlleriPad.h"

#import "IpadGridViewCell.h"
#import "YKYouTubeVideo.h"
#include "YoutubeParser.h"
#import "VideoDetailViewController.h"
#import "GGTabBarController.h"
#import "GGLayoutStringTabBar.h"


@interface VideoDetailViewControlleriPad ()<YoutubeCollectionNextPageDelegate, GGTabBarControllerDelegate> {
   NSArray * _lastControllerArray;
}

@property(strong, nonatomic) IBOutlet UIView * videoPlayViewContainer;
@property(strong, nonatomic) IBOutlet UIView * detailViewContainer;
@property(strong, nonatomic) IBOutlet UIView * tabBarViewContainer;

@end


@implementation VideoDetailViewControlleriPad

#pragma mark -
#pragma mark - UIView cycle


- (instancetype)initWithDelegate:(id<IpadGridViewCellDelegate>)delegate video:(YTYouTubeVideoCache *)video {
   self = [super init];
   if (self) {
      self.delegate = delegate;
      self.video = video;
   }

   return self;
}


- (void)viewDidLoad {
   [super viewDidLoad];

   // Do any additional setup after loading the view, typically from a nib.
   self.view.backgroundColor = [UIColor clearColor];

   [self initViewControllers];
   [self setupPlayer:self.videoPlayViewContainer];

   self.title = [YoutubeParser getVideoSnippetTitle:self.video];

//   [self executeRefreshTask];// test
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.

}


#pragma mark -
#pragma mark - setup UIView


- (void)initViewControllers {
   // 1
   self.firstViewController = [[UIViewController alloc] init];
   self.firstViewController.title = @"Comments";

   self.secondViewController = [[UIViewController alloc] init];
   self.secondViewController.title = @"More From";

   self.thirdViewController = [[YTCollectionViewController alloc] init];
   self.thirdViewController.delegate = self.delegate;
   self.thirdViewController.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"2", nil];
   self.thirdViewController.title = @"Suggestions";

   [self.thirdViewController fetchSuggestionListByVideoId:[YoutubeParser getWatchVideoId:self.video]];
   self.thirdViewController.nextPageDelegate = self;

   // 2
   self.videoDetailController = [[VideoDetailViewController alloc] initWithVideo:self.video];
}


- (void)makeTabBarController:(UIView *)parentView withControllerArray:(NSArray *)controllerArray {
   // 2
   GGTabBar * topTabBar = [[GGLayoutStringTabBar alloc] initWithFrame:CGRectZero
                                                      viewControllers:controllerArray
                                                                inTop:YES
//                                                        selectedIndex:controllerArray.count - 1
                                                        selectedIndex:0
                                                          tabBarWidth:0];

   GGTabBarController * tabBarController = [[GGTabBarController alloc] initWithTabBarView:topTabBar];
   tabBarController.delegate = self;

   tabBarController.view.frame = parentView.bounds;// used
   tabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

   // 3
   self.videoTabBarController = tabBarController;

   // 4
   [parentView addSubview:self.videoTabBarController.view];
}


- (NSArray *)getTabBarControllerArray {
   UIInterfaceOrientation toInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
   BOOL isPortrait = (toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
   if (isPortrait) {
      NSArray * array = @[
       self.videoDetailController,
       self.firstViewController,
       self.secondViewController,
       self.thirdViewController, ];
      return array;
   } else {
      return @[
       self.firstViewController,
       self.secondViewController,
       self.thirdViewController, ];
   }

   return nil;
}


- (void)removeDetailPanel:(UIView *)pView {
//   [self.videoDetailController.view removeFromSuperview];
//   [self.detailViewContainer removeFromSuperview];
}


- (void)selectDetailViewControllerInHorizontal:(UIViewController *)viewController {
   UIView * presentedView = [self.detailViewContainer.subviews firstObject];
   if (presentedView) {
      [presentedView removeFromSuperview];
   }

   viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
   [self.detailViewContainer addSubview:viewController.view];
   [self fitView:viewController.view intoView:self.detailViewContainer];
}


- (void)fitView:(UIView *)toPresentView intoView:(UIView *)containerView {
   NSDictionary * viewsDictioanry = @{ @"detailView_Container" : toPresentView };

   [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[detailView_Container]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictioanry]];

   [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailView_Container]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictioanry]];
}


- (void)addDetailPanel:(UIView *)pView {
   [self.videoDetailController.view removeConstraints:[self.videoDetailController.view constraints]];

   // 2
   [pView addSubview:self.videoDetailController.view];
   self.videoDetailController.view.frame = pView.bounds;
}


- (void)setupPlayer:(UIView *)pView {
   [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
   self.youTubeVideo = [[YKYouTubeVideo alloc] initWithVideoId:[YoutubeParser getWatchVideoId:self.video]];

   //Fetch thumbnail
   [self.youTubeVideo parseWithCompletion:^(NSError * error) {
       //Then play (make sure that you have called parseWithCompletion before calling this method)
       [self.youTubeVideo playInView:pView withQualityOptions:YKQualityLow];
   }];
}


#pragma mark -
#pragma mark Rotation stuff


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

   [self updateLayout:[UIApplication sharedApplication].statusBarOrientation];
}


- (void)updateLayout:(UIInterfaceOrientation)toInterfaceOrientation {
   BOOL isPortrait = (toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);

   NSArray * array = [self getTabBarControllerArray];
   if (_lastControllerArray && (array.count != _lastControllerArray.count)) {
      _lastControllerArray = nil;
   }
   if (_lastControllerArray == nil) {
      [self makeTabBarController:self.tabBarViewContainer withControllerArray:array];
      _lastControllerArray = array;
   }


   if (isPortrait) {// 4
      // 1  UIView contains
      [self removeDetailPanel:self.detailViewContainer];
      // 2  layout
      [self setupVerticalLayout];
   } else {// 3
      // 1  UIView contains
//      [self addDetailPanel:self.detailViewContainer];
      [self selectDetailViewControllerInHorizontal:self.videoDetailController];
      // 2 layout
      [self setupHorizontalLayout];
   }

//   [self.videoDetailController.view setNeedsLayout];
//   [self.selectedController.view setNeedsLayout];
}


- (void)setupHorizontalLayout {
   CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
   CGFloat statusBarHeight = statusRect.size.height;
   CGFloat navBarHeight = 44;
   CGFloat topHeight = statusBarHeight + navBarHeight;
   CGFloat tabBarHeight = 50;

   CGFloat aHaflWidth = self.view.frame.size.width / 2;
   CGFloat aHeight = self.view.frame.size.height - topHeight - tabBarHeight;

   CGRect rect = self.videoPlayViewContainer.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight;
   rect.size.width = aHaflWidth;
   rect.size.height = aHeight / 2;
   self.videoPlayViewContainer.frame = rect;

   rect = self.detailViewContainer.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight + aHeight / 2;
   rect.size.width = aHaflWidth;
   rect.size.height = aHeight / 2;
   self.detailViewContainer.frame = rect;

   rect = self.tabBarViewContainer.frame;
   rect.origin.x = aHaflWidth;
   rect.origin.y = topHeight;
   rect.size.width = aHaflWidth;
   rect.size.height = aHeight;
   self.tabBarViewContainer.frame = rect;
}


- (void)setupVerticalLayout {
   CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
   CGFloat statusbarHeight = statusRect.size.height;
   CGFloat navbarHeight = 44;
   CGFloat topHeight = statusbarHeight + navbarHeight;
   CGFloat tabbarHeight = 50;

   CGFloat aWidth = self.view.frame.size.width;
   CGFloat aHeight = self.view.frame.size.height - topHeight - tabbarHeight;

   CGRect rect = self.videoPlayViewContainer.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight;
   rect.size.width = aWidth;
   rect.size.height = aHeight / 2;
   self.videoPlayViewContainer.frame = rect;

   rect = self.tabBarViewContainer.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight + aHeight / 2;
   rect.size.width = aWidth;
   rect.size.height = aHeight / 2;
   self.tabBarViewContainer.frame = rect;
}


#pragma mark -
#pragma mark GGTabBarControllerDelegate


- (BOOL)ggTabBarController:(GGTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
   return YES;
}


- (void)ggTabBarController:(GGTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
   self.selectedController = viewController;
//   [viewController.view setNeedsLayout];
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
   [self.thirdViewController fetchSuggestionListByVideoId:[YoutubeParser getWatchVideoId:self.video]];
}


- (void)executeNextPageTask {
   [self.thirdViewController fetchSuggestionListByPageToken];
}


@end
