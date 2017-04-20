//
//  CSErrorTips.h
//  SellHouseManager
//
//  Created by luoyan on 16/5/17.
//  Copyright © 2016年. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ErrorTipsType)
{
    ErrorTipsType_BadNetWork,
    ErrorTipsType_ServerError,
    ErrorTipsType_NoData,
    ErrorTipsType_Loading,
    ErrorTipsType_NoCustomerData,
    ErrorTipsType_NoDataLeftTop,
};

typedef void(^RepeatLoadActionBlock)(void);

@interface CSErrorTips : UIView

@property (nonatomic, copy) RepeatLoadActionBlock repeatLoadBlock;

- (void)reloadTips:(NSString*)tips subTips:(NSString*)subTips withType:(ErrorTipsType)type;

- (void)hideTipsView;
@end
