//
//  MyRefreshHUD.m
//  SellHouseManager
//
//  Created by 文俊 on 16/5/13.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "MyRefreshHUD.h"

@interface MyRefreshHUD ()


@end

@implementation MyRefreshHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = self.bounds;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel = titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.size = self.bounds.size;
}

- (void)showWithView:(UIView*)view
{
    _titleLabel.top = -self.height;
    [view addSubview:self];
    [self showHUD];
}

- (void)showHUD
{
    @weakify(self);
    [UIView animateWithDuration:1 animations:^{
        @strongify(self);
        self.titleLabel.top = 0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hiddenHUD) withObject:nil afterDelay:1];
    }];
}

- (void)hiddenHUD
{
    @weakify(self);
    [UIView animateWithDuration:1 animations:^{
        @strongify(self);
        self.titleLabel.top = -self.height;
    } completion:^(BOOL finished) {
        @strongify(self);
        [self removeFromSuperview];
    }];
}

+ (MyRefreshHUD *)showSucceedView:(UIView*)view
{
    return [self showSucceedView:view title:@"数据加载完成"];
}

+ (MyRefreshHUD *)showSucceedView:(UIView*)view offset:(CGPoint)offset
{
    return [self showView:view offset:offset backgroundColor:kMainColor title:@"数据加载完成"];
}

+ (MyRefreshHUD *)showSucceedView:(UIView*)view title:(NSString*)title
{
    return [self showView:view offset:CGPointZero backgroundColor:kMainColor title:title];
}

+ (MyRefreshHUD *)showFailView:(UIView*)view
{
    return [self showFailView:view title:@"数据加载失败"];
}

+ (MyRefreshHUD *)showFailView:(UIView*)view offset:(CGPoint)offset
{
    return [self showView:view offset:offset backgroundColor:UIColorHex(0xff6259) title:@"数据加载失败"];
}

+ (MyRefreshHUD *)showFailView:(UIView*)view title:(NSString*)title
{
    return [self showView:view offset:CGPointZero backgroundColor:UIColorHex(0xff6259) title:title];
}

+ (MyRefreshHUD *)showView:(UIView*)view offset:(CGPoint)offset backgroundColor:(UIColor*)backgroundColor title:(NSString*)title
{
    MyRefreshHUD *refreshHUD = [[MyRefreshHUD alloc] initWithFrame:CGRectMake(offset.x, offset.y, view.width, 27)];
    refreshHUD.titleLabel.backgroundColor = backgroundColor;
    refreshHUD.titleLabel.text = title;
    [refreshHUD showWithView:view];
    return refreshHUD;
}

@end
