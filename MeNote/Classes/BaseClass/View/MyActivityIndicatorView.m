//
//  MyActivityIndicatorView.m
//  SellHouseManager
//
//  Created by 文俊 on 16/5/13.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "MyActivityIndicatorView.h"

@implementation MyActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.hidesWhenStopped = YES;
        self.steps = 8;
        self.color = UIColorRGB(153, 153, 153);
    }
    return self;
}

@end
