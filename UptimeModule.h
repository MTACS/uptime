#import "UptimeModuleContentViewController.h"

@interface NSUserDefaults (Uptime)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface UptimeModule : NSObject <CCUIContentModule>
@property (nonatomic, readonly) UptimeModuleContentViewController *contentViewController;
@property (readonly, nonatomic) UIViewController *backgroundViewController;
@end