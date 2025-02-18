#import "UptimeModuleContentViewController.h"

@implementation UptimeModuleContentViewController
- (instancetype)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle {
    self = [super initWithNibName:name bundle:bundle];
    if (self) {
        self.view.clipsToBounds = YES;
        _uptimeButton = [[UptimeButtonController alloc] init];
        [self loadContent];
    }
    return self;
}
- (void)loadContent {
    _uptimeButton.view.layer.masksToBounds = YES;
    _uptimeButton.view.layer.cornerRadius = 37.5;

    [self addChildViewController:_uptimeButton];
    [self.view addSubview:_uptimeButton.view];

    _uptimeButton.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [_uptimeButton.view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_uptimeButton.view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [_uptimeButton.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [_uptimeButton.view.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
    ]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _preferredExpandedContentWidth = WIDTH * 0.6;
    _preferredExpandedContentHeight = 150;
}
- (BOOL)_canShowWhileLocked {
	return YES;
}
- (BOOL)shouldPerformClickInteraction {
    return YES;
}
- (void)controlCenterDidDismiss {
    [_uptimeButton removeTimer];
}
- (void)controlCenterWillPresent {
    [_uptimeButton addTimer];
}
@end

@implementation UptimeButtonController {
    NSTimer *_uptimeTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.uptimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.uptimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.uptimeLabel.textColor = [UIColor whiteColor];
    self.uptimeLabel.numberOfLines = 2;
    self.uptimeLabel.textAlignment = NSTextAlignmentCenter;
    self.uptimeLabel.center = self.view.center;
    [self.view addSubview:self.uptimeLabel];

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1x1", @"1x2"]];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    segmentedControl.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
    segmentedControl.selectedSegmentTintColor = [UIColor colorWithWhite:0.75 alpha:0.5];
    segmentedControl.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"displaySize" inDomain:domain] integerValue];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    [segmentedControl addTarget:self action:@selector(setModuleSize:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];

    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    sizeLabel.text = @"Module Size";
    sizeLabel.font = [UIFont systemFontOfSize:10];
    sizeLabel.textAlignment = NSTextAlignmentCenter;
    sizeLabel.textColor = [UIColor colorWithWhite:0.75 alpha:0.75];
    sizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:sizeLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.uptimeLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.uptimeLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:5],
        [self.uptimeLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-5],
        [self.uptimeLabel.heightAnchor constraintEqualToConstant:72],
        [segmentedControl.topAnchor constraintEqualToAnchor:self.uptimeLabel.bottomAnchor constant:10],
        [segmentedControl.widthAnchor constraintEqualToConstant:150],
        [segmentedControl.heightAnchor constraintEqualToConstant:30],
        [segmentedControl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [sizeLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [sizeLabel.topAnchor constraintEqualToAnchor:segmentedControl.bottomAnchor],
        [sizeLabel.widthAnchor constraintEqualToConstant:100],
        [sizeLabel.heightAnchor constraintEqualToConstant:30],
    ]];
    [self addTimer];
}
- (void)setModuleSize:(UISegmentedControl *)control {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:control.selectedSegmentIndex] forKey:@"displaySize" inDomain:domain];
    CCUIModuleCollectionViewController *moduleController = self.presentingViewController.childViewControllers.lastObject;
    if (moduleController) {
        [moduleController _updateModuleControllers];
    }
}
- (void)addTimer {
    _uptimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setUptimeText) userInfo:nil repeats:YES];
    self.uptimeLabel.center = self.view.center;
}
- (void)removeTimer {
    [_uptimeTimer invalidate];
    _uptimeTimer = nil;
}
- (void)setUptimeText {
    time_t uptimeInterval = [self getDeviceUptime];

    long seconds = uptimeInterval % 60;
    long minutes = uptimeInterval / 60 % 60;
    long hours = uptimeInterval / 60 / 60 % 24;
    long days = uptimeInterval / 60 / 60 / 24;

    NSString *uptimeText = @"";
    if (days != 0) {
        uptimeText = [uptimeText stringByAppendingString:[NSString stringWithFormat:@"%ldd ", days]];
    }
    if (hours != 0) {
        uptimeText = [uptimeText stringByAppendingString:[NSString stringWithFormat:@"%ldh ", hours]];
    }
    if (minutes != 0) {
        uptimeText = [uptimeText stringByAppendingString:[NSString stringWithFormat:@"%ldm ", minutes]];
    }
    uptimeText = [uptimeText stringByAppendingString:[NSString stringWithFormat:@"%lds", seconds]];
    self.uptimeLabel.text = uptimeText;


    self.uptimeLabel.font = [UIFont systemFontOfSize:([[[NSUserDefaults standardUserDefaults] objectForKey:@"displaySize"] integerValue] == 0) ? 14 : 16];
}
- (time_t)getDeviceUptime {
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptimeInterval = -1;
    (void)time(&now);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptimeInterval = now - boottime.tv_sec;
    }
    return uptimeInterval;
}
- (BOOL)_canShowWhileLocked {
	return YES;
}
@end