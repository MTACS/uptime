#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#include <sys/sysctl.h>  

typedef struct CCUILayoutSize {
	unsigned long long width;
	unsigned long long height;
} CCUILayoutSize;

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
@end

@interface UptimeModuleContentViewController : UIViewController <CCUIContentModuleContentViewController>
@property (nonatomic, readonly) CGFloat preferredExpandedContentHeight;
@property (nonatomic, readonly) CGFloat preferredExpandedContentWidth;
@property (nonatomic, strong) UptimeButtonController *uptimeButton;
@property (nonatomic, readonly) BOOL expanded;
- (void)controlCenterDidDismiss;
- (void)controlCenterWillPresent;
@end