//
//  GPSServerManager.h
//  WinWin
//
//  Created by luoyan on 16/12/29.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>

typedef void(^AuthorizationResult)(BOOL result);

@interface GPSServerManager : NSObject

+ (instancetype)shareInstance;

- (void)requestAuthorization;

@property (nonatomic, copy) AuthorizationResult resultBlock;

@end
