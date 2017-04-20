//
//  DataManager.h
//  SellHouseManager
//
//  Created by wenjun on 15/3/6.
//  Copyright (c) 2015年 wenjun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GetDataManager [DataManager sharedManager]
#define GetDataUid [DataManager sharedManager].userId


@interface DataManager : NSObject

@property (nonatomic, assign, readonly) UInt64 userId;

#pragma mark -
+ (DataManager *)sharedManager;

@end

