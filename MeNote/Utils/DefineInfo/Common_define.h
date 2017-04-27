//  功能描述：常用宏定义

/***common**/
#import "AppDelegate.h"
#import "Common_font.h"
#import "Common_color.h"
#import "Common_limit.h"
#import "Common_image.h"
#import "Common_GlobalKey.h"

/***类别***/
#import "Common_categories.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import "NSString+MyString.h"

/***View***/
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYFooter.h"
#import "MyRefreshHUD.h"

/***Manager***/
#import "HUDManager.h"
//#import <IQKeyboardManager.h>

/***Util***/
#import "RegexKitLite.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "DataManager.h"
#import "UtilTextLimit.h"
#import "MicAssistant.h"
#import "SSZipArchive.h"

/***Model***/
#import "StatusModel.h"
#import "MNUserInfo.h"

/***Configure***/
#import "AutoSizeCGRect.h"
#import "ReactiveCocoa.h"
#import "MNNetConfigure.h"

#ifndef Common_define_h
#define Common_define_h

/********************** 常用宏 ****************************/
#pragma mark - 常用宏

/**  *  1 判断是否为3.5inch      320*480  */
#define ONESCREEN ([UIScreen mainScreen].bounds.size.height == 480)
/**  *  2 判断是否为4inch        640*1136  */
#define TWOSCREEN ([UIScreen mainScreen].bounds.size.height == 568)
/**  *  3 判断是否为4.7inch   375*667   750*1334  */
#define THREESCREEN ([UIScreen mainScreen].bounds.size.height == 667)
/**  *  4 判断是否为5.5inch   414*736   1242*2208  */
#define FOURSCREEN ([UIScreen mainScreen].bounds.size.height == 736)

/// 判断无网络情况
#define GetNetworkStatusNotReachable ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)

/// 当前版本号
#define GetCurrentVersion ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])

/// 当前app名称
#define GetAppName ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"])

/// 当前app delegate
#define GetAPPDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

/// 获取queue
#define GetMainQueue dispatch_get_main_queue()
#define GetGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

/// block self
#define kSelfWeak __weak typeof(self) weakSelf = self
#define kSelfStrong __strong __typeof__(weakSelf) strongSelf = weakSelf

// url
#define URLWithString(str)  [NSURL URLWithString:str]

//方法简介
#define AddNotification(observer,sel,key,obj)   [[NSNotificationCenter defaultCenter] addObserver:observer selector:sel name:key object:obj]
#define PostNotification(name,obj)              [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj]
#define kBorderLine [[MyBorderLineDraw alloc] initWithColor:kSplitLineColor]

/// Height/Width
#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kBodyHeight             ([UIScreen mainScreen].bounds.size.height - kNavigationHeight - kStatusBarHeight)
#define kTabbarRootBodyHeight   (kBodyHeight - kTabbarHeight)
#define kTabbarHeight       49.0
#define kSearchBarHeight    45.0
#define kStatusBarHeight    20.0
#define kNavigationHeight   44.0
#define kMarginWidth        15.0    //内容到屏幕的边距
#define kLineHeight         50.0    //行高度
#define kAreaHeight         40.0    //模块的title栏高度
#define kLineTitleHeight    45.0    //行标题栏的高度
#define kAreaPaddingHeight  10.0    //块之间的间距
#define ScreenMutiple6 (iPhone6?1:(iPhone6plus?1.104:0.853))    //以iphone6尺寸为标准

/// System判断
#define ISiPod      [[[UIDevice currentDevice] model] isEqual:@"iPod touch"]
#define ISiPhone    [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define ISiPad      [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define ISiPhone4   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone5   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)


// end
#define ISIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) // IOS6的系统
#define ISIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) // IOS7的系统
#define ISIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) // IOS8的系统
#define ISIOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) // IOS9的系统


#define UIInterfaceOrientationIsPortrait(orientation)  ((orientation) == UIInterfaceOrientationPortrait || (orientation) == UIInterfaceOrientationPortraitUpsideDown)
#define UIInterfaceOrientationIsLandscape(orientation) ((orientation) == UIInterfaceOrientationLandscapeLeft || (orientation) == UIInterfaceOrientationLandscapeRight)

#define INTERFACEPortrait self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
#define INTERFACELandscape self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define DLog(...)
#define NSLog(...) {}
#endif

/********************** 数值 ****************************/
/// 数值转字符串
#define kIntToString(intValue) ([NSString stringWithFormat:@"%@", @(intValue)])
#define kNumberToString(NumberValue) ([NSString stringWithFormat:@"%@", NumberValue])
#define StrToInt(str) [str integerValue]
#define StrToDouble(str) [str doubleValue]
#define kDoubleToString(num) [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", num]] stringValue]
#define kDoubleToString2(num) [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2lf", num]] stringValue]
#define NSStringFromNumber(num) [@(num) stringValue]


/********************** 标识 ****************************/

#pragma mark - 标识

#define IQKeyboardDistanceFromTextField 50


#define firstCategoryWidth (AutoWHGetWidth(70))

#define SaveObjToUserDefaults(obj,key)  [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]

#define SaveBOOLToUserDefaults(bool,key)  [[NSUserDefaults standardUserDefaults] setBool:bool forKey:key]
#define GetBoolFromUserDefaults(key)      [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define synUserDefaults                   [[NSUserDefaults standardUserDefaults] synchronize]


// 定义是否打开指定app
#define CanOpenAppURL(urlScheme) [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlScheme]]

// 定义开发指定app
#define OpenAppURL(urlScheme) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]]

//----------方法简写-------
#define kApplication        [UIApplication sharedApplication]
#define kAppDelegate        (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define kWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define kKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]



#endif
