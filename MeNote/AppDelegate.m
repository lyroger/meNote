//
//  AppDelegate.m
//  MeNote
//
//  Created by luoyan on 2017/4/20.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "AppDelegate.h"
#import "MNNavigationController.h"
#import "MNLoginViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) MNLoginViewController *loginVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    sleep(1);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self authorizeOperation];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)authorizeOperation
{
    //加载本地用户信息
    [[MNUserInfo shareUserInfo] getUserInfoFromLocal];
    
    [MNUserInfo shareUserInfo].token = @"aweifawenfalef";
    //不需要加载启动页则判断是否需要登录
    if (![MNUserInfo shareUserInfo].token.length) {
        self.loginVC = [[MNLoginViewController alloc] init];
        @weakify(self)
        MNNavigationController *rootNav = [[MNNavigationController alloc] initWithRootViewController:self.loginVC];
        self.loginVC.loginCompleteBlock = ^(BOOL success){
            @strongify(self)
            if (success) {
               [self enterRootView];
            }
        };
        self.window.rootViewController = rootNav;
        
    } else {
        [self enterRootView];
    }
}

- (void)enterRootView
{
    self.rootViewController = [[MNRootViewController alloc] init];
    MNNavigationController *rootNav = [[MNNavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = rootNav;
    
    //如果登录页面存在，则做一个登录页面退场效果。
    if (self.loginVC) {
        [self.rootViewController.view addSubview:self.loginVC.view];
        self.loginVC.view.alpha = 1;
        self.loginVC.view.transform = CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.loginVC.view.alpha = 0;
            self.loginVC.view.transform = CGAffineTransformMakeScale(2.5, 2.5);
        } completion:^(BOOL finished) {
            [self.loginVC.view removeFromSuperview];
            self.loginVC = nil;
            NSLog(@"登录页面释放-动画结束");
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
