//
//  GPSServerManager.m
//  WinWin
//
//  Created by luoyan on 16/12/29.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "GPSServerManager.h"

@interface GPSServerManager()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation GPSServerManager

+ (instancetype)shareInstance
{
    static GPSServerManager *shareManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareManager = [[GPSServerManager alloc] init];
    });
    return shareManager;
}

- (void)requestAuthorization
{
    //获取授权认证
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
            //用户选择取消授权
        case kCLAuthorizationStatusDenied:
            if (self.resultBlock) {
                self.resultBlock(NO);
                self.resultBlock = nil;
            }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (self.resultBlock) {
                self.resultBlock(YES);
                self.resultBlock = nil;
            }
            break;
        default:
            break;
    }
    
}
@end
