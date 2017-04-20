//
//  MJDIYFooter.m
//  SellHouseManager
//
//  Created by 文俊 on 2016/11/18.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "MJDIYFooter.h"

@implementation MJDIYFooter

#pragma mark - 重写方法
- (void)prepare
{
    [super prepare];
    
    // 设置字体
    self.stateLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    self.stateLabel.textColor = kFontGrayColor;
}

@end
