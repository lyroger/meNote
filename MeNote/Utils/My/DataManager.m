//
//  DataManager.m
//  SellHouseManager
//
//  Created by wenjun on 15/3/6.
//  Copyright (c) 2015年 wenjun. All rights reserved.
//

#import "DataManager.h"
@interface DataManager ()

@end

@implementation DataManager


+ (DataManager *)sharedManager{
    static DataManager *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[DataManager alloc] init];
        assert(sharedManager != nil);
    });
    return sharedManager;
}
@end
