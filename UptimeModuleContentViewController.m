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
    _uptimeButton.view.layer.cornerRadius = 40;

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
    _preferredExpandedContentWidth = 200;
    _preferredExpandedContentHeight = 80;
}
- (BOOL)_canShowWhileLocked {
	return YES;
}
- (BOOL)shouldPerformClickInteraction {
    return NO;
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

    self.uptimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 60)];
    self.uptimeLabel.font = [UIFont systemFontOfSize:14];
    self.uptimeLabel.textColor = [UIColor whiteColor];
    self.uptimeLabel.numberOfLines = 2;
    self.uptimeLabel.textAlignment = NSTextAlignmentCenter;
    self.uptimeLabel.center = self.view.center;
    [self.view addSubview:self.uptimeLabel];
    [self addTimer];
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

    NSString *uptimeText = [NSString stringWithFormat:@"System Uptime:\n"]; 
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
@end