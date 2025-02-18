#import "UptimeModule.h"
#import "UptimeModuleContentViewController.h"
#import <objc/runtime.h>

@implementation UptimeModule
- (instancetype)init {
    self = [super init];
    if (self) {
        _contentViewController = [[UptimeModuleContentViewController alloc] init];
	}
    return self;
}
- (CCUILayoutSize)moduleSizeForOrientation:(int)orientation {
    NSInteger size = [[[NSUserDefaults standardUserDefaults] objectForKey:@"displaySize" inDomain:@"com.mtac.uptime"] integerValue];
    return (size == 0) ? (CCUILayoutSize){1, 1} : (CCUILayoutSize){2, 1};
}
@end