#import "UptimeModuleContentViewController.h"

@interface UptimeModule : NSObject <CCUIContentModule>
@property (nonatomic, readonly) UptimeModuleContentViewController *contentViewController;
@property (readonly, nonatomic) UIViewController *backgroundViewController;
@end