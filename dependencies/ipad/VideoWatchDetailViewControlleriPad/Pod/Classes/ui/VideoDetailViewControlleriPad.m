#import "VideoDetailViewControlleriPad.h"


#import "WHTopTabBarController.h"

#import "IpadGridViewCell.h"
#import "YKYouTubeVideo.h"
#include "YoutubeParser.h"
#import "VideoDetailViewController.h"


@interface VideoDetailViewControlleriPad ()<YoutubeCollectionNextPageDelegate>

@property(strong, nonatomic) IBOutlet UIView * videoPlayView;
@property(strong, nonatomic) IBOutlet UIView * detailView;
@property(strong, nonatomic) IBOutlet UIView * tabbarView;

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
   [self setupPlayer:self.videoPlayView];

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
   self.videoDetailController.title = @"Info";


   // 3
   self.videoTabBarController = [[WHTopTabBarController alloc] init];
   self.videoTabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [self.tabbarView addSubview:self.videoTabBarController.view];

   // 5
   self.defaultTableControllers = [NSArray arrayWithObjects:
    self.firstViewController,
    self.secondViewController,
    self.thirdViewController,
     nil];
}


- (void)setupTabbarPanelInHorizontal:(UIView *)view {
   NSArray * array = [self.defaultTableControllers copy];

   self.videoTabBarController.viewControllers = array;
   self.videoTabBarController.selectedIndex = array.count - 1;
}


- (void)setupTabbarPanelInVertical:(UIView *)view {
   NSMutableArray * array = [self.defaultTableControllers mutableCopy];
   [array insertObject:self.videoDetailController atIndex:0];

   self.videoTabBarController.viewControllers = array;
   self.videoTabBarController.selectedIndex = array.count - 1;
}


- (void)removeDetailPanel:(UIView *)pView {
   [self.detailView removeFromSuperview];
}


- (void)addDetailPanel:(UIView *)pView {
   // 1
   [self.view addSubview:pView];
   // 2
   [pView addSubview:self.videoDetailController.view];
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
   if (isPortrait) {
      // 1  UIView contains
      [self setupTabbarPanelInVertical:self.tabbarView];
      [self removeDetailPanel:self.detailView];
      // 2  layout
      [self setupVerticalLayout];
      [self setupUIViewVerticalLayout];
   } else {
      // 1  UIView contains
      [self setupTabbarPanelInHorizontal:self.tabbarView];
      [self addDetailPanel:self.detailView];
      // 2 layout
      [self setupHorizontalLayout];
      [self setupUIViewHorizontalLayout];
   }

   [self.youTubeVideo setVideoLayout:self.videoPlayView];
   self.videoTabBarController.view.frame = self.tabbarView.bounds;

//   self.videoDetailPanel.view.frame = self.videoDetailController.view.frame;
//   self.videoDetailPanel.frame = self.videoDetailController.view.frame;
//   [self.videoDetailPanel setCurrentFrame:self.videoDetailController.view.frame];
}


- (void)setupHorizontalLayout {
   CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
   CGFloat statusbarHeight = statusRect.size.height;
   CGFloat navbarHeight = 44;
   CGFloat topHeight = statusbarHeight + navbarHeight;
   CGFloat tabbarHeight = 50;

   CGFloat aHaflWidth = self.view.frame.size.width / 2;
   CGFloat aHeight = self.view.frame.size.height - topHeight - tabbarHeight;

   CGRect rect = self.videoPlayView.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight;
   rect.size.width = aHaflWidth;
   rect.size.height = aHeight / 2;
   self.videoPlayView.frame = rect;

   rect = self.detailView.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight + aHeight / 2;
   rect.size.width = aHaflWidth;
   rect.size.height = aHeight / 2;
   self.detailView.frame = rect;

   rect = self.tabbarView.frame;
   rect.origin.x = aHaflWidth;
   rect.origin.y = topHeight;
   rect.size.width = aHaflWidth;
   rect.size.height = aHeight;
   self.tabbarView.frame = rect;
}


- (void)setupUIViewHorizontalLayout {
   self.videoDetailController.view.frame = self.detailView.bounds;
}


- (void)setupVerticalLayout {
   CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
   CGFloat statusbarHeight = statusRect.size.height;
   CGFloat navbarHeight = 44;
   CGFloat topHeight = statusbarHeight + navbarHeight;
   CGFloat tabbarHeight = 50;

   CGFloat aWidth = self.view.frame.size.width;
   CGFloat aHeight = self.view.frame.size.height - topHeight - tabbarHeight;

   CGRect rect = self.videoPlayView.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight;
   rect.size.width = aWidth;
   rect.size.height = aHeight / 2;
   self.videoPlayView.frame = rect;

   rect = self.tabbarView.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight + aHeight / 2;
   rect.size.width = aWidth;
   rect.size.height = aHeight / 2;
   self.tabbarView.frame = rect;
}


- (void)setupUIViewVerticalLayout {

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
