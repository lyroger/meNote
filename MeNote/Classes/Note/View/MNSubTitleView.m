//
//  MNSubTitleView.m
//  MeNote
//
//  Created by 罗琰 on 2017/4/26.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNSubTitleView.h"

@interface MNSubTitleView()
{
    UILabel *titleLabel;
    UILabel *subTitleLabel;
}

@end

@implementation MNSubTitleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = UIColorHex(0x888888);
        titleLabel.font = kFontPingFangRegularSize(15);
        [self addSubview:titleLabel];
        
        subTitleLabel = [UILabel new];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.textColor = UIColorHex(0x888888);
        subTitleLabel.font = kFontPingFangRegularSize(15);
        [self addSubview:subTitleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.bottom.equalTo(subTitleLabel.mas_top).offset(0);
        }];
        
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(0);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@(-5));
        }];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    subTitleLabel.text = subTitle;
}

@end
