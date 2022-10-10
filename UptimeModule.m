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
    return (CCUILayoutSize){2, 1};
}
@end