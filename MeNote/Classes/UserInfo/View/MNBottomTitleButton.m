//
//  MNBottomTitleButton.m
//  MeNote
//
//  Created by luoyan on 2017/4/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNBottomTitleButton.h"

@implementation MNBottomTitleButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.button];
        
        self.label = [UILabel new];
        self.label.font = kFontPingFangRegularSize(12);
        self.label.textColor = UIColorHex(0x888888);
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.bottom.equalTo(self.label.mas_top).offset(-12);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.button.mas_bottom).offset(12);
            make.bottom.right.left.equalTo(@0);
            make.height.equalTo(@14);
        }];
    }
    return self;
}

@end
