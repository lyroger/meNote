//
//  MyRefreshHUD.h
//  SellHouseManager
//
//  Created by 文俊 on 16/5/13.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRefreshHUD : UIView

@property (nonatomic, weak) UILabel *titleLabel;

+ (MyRefreshHUD *)showSucceedView:(UIView*)view;

+ (MyRefreshHUD *)showSucceedView:(UIView*)view offset:(CGPoint)offset;

+ (MyRefreshHUD *)showSucceedView:(UIView*)view title:(NSString*)title;

+ (MyRefreshHUD *)showFailView:(UIView*)view;

+ (MyRefreshHUD *)showFailView:(UIView*)view offset:(CGPoint)offset;

+ (MyRefreshHUD *)showFailView:(UIView*)view title:(NSString*)title;

+ (MyRefreshHUD *)showView:(UIView*)view offset:(CGPoint)offset backgroundColor:(UIColor*)backgroundColor title:(NSString*)title;

@end
