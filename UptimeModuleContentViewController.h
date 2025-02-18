#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#include <sys/sysctl.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.width
#define PREFS [[NSUserDefaults alloc] initWithSuiteName:@"com.mtac.uptime"]

static NSString *domain = @"com.mtac.uptime";
static NSString *PostNotificationString = @"com.mtac.uptime/loadSettings";

typedef struct CCUILayoutSize {
	unsigned long long width;
	unsigned long long height;
} CCUILayoutSize;

@interface NSUserDefaults (Uptime)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface UIView (Uptime)
- (id)_viewControllerForAncestor;
@end

@interface CCUIModuleCollectionViewController : UIViewController
- (void)_updateModuleControllers;
@end

@interface CCUILabeledRoundButtonViewController : UIViewController
@end

@protocol CCUIContentModuleContentViewController <NSObject>
@end

@protocol CCUIContentModule <NSObject>
@end

@interface UptimeButtonController: UIViewController
@property (nonatomic, strong) UILabel *uptimeLabel;
- (void)addTimer;
- (void)removeTimer;
- (void)setModuleSize:(UISegmentedControl *)control;
@end

@interface UptimeModuleContentViewController : UIViewController <CCUIContentModuleContentViewController>
@property (nonatomic, readonly) CGFloat preferredExpandedContentHeight;
@property (nonatomic, readonly) CGFloat preferredExpandedContentWidth;
@property (nonatomic, readonly) BOOL expanded;
@property (nonatomic, strong, readwrite) UptimeButtonController *uptimeButton;
- (void)controlCenterDidDismiss;
- (void)controlCenterWillPresent;
@end