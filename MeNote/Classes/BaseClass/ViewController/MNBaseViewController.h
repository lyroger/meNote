//
//  SHMBaseViewController.h
//  SellHouseManager
//
//  Created by luoyan on 16/5/3.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSErrorTips.h"

@interface MNBaseViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *networkOperations;

//设置导航栏右按钮
- (void)rightBarButtonWithName:(NSString *)name
                 normalImgName:(NSString *)normalImgName
              highlightImgName:(NSString *)highlightImgName
                        target:(id)target
                        action:(SEL)action;

//白色圆框文字
- (void)rightBarRoundedBtnNames:(NSArray *)names
                         target:(id)target
                         action:(SEL)action;

//设置导航栏左边按钮
- (void)leftBarButtonWithName:(NSString *)name
                        image:(UIImage *)image
                       target:(id)target
                       action:(SEL)action;

/// 返回上层视图方法
- (void)backToSuperView;

// 点击空白处键盘收回
- (void)textFieldReturn;

#pragma mark - 网络
/// 添加网络操作，便于释放
- (void)addNet:(NSURLSessionDataTask *)net;

/// 释放网络
- (void)releaseNet;

//加载数据、数据返回提示视图，服务器错误的可以无需传tips；全局页面加载的无需传frame
- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type  superView:(UIView*)superView frame:(CGRect)frame;
- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type frame:(CGRect)frame;
- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type superView:(UIView*)superView;
- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type;
- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type  superView:(UIView*)superView frame:(CGRect)frame;
- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type frame:(CGRect)frame;
- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type superView:(UIView*)superView;
- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type;
- (CSErrorTips*)showLoadType:(ErrorTipsType)type;

//隐藏加载数据、数据返回提示视图；
- (void)hideTipsView;
//重新请求数据
- (void)needReloadData;

- (BOOL)isTipsViewHidden;

@end
