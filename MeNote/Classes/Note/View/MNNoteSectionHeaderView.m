//
//  MNNoteSectionHeaderView.m
//  MeNote
//
//  Created by 罗琰 on 2017/4/24.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNNoteSectionHeaderView.h"

@interface MNNoteSectionHeaderView()
{
    UIImageView *lineImage;
    UIImageView *timeImage;
}

@end

@implementation MNNoteSectionHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorHex(0xf5f6f8);
        lineImage = [UIImageView new];
        lineImage.image = [UIImage imageNamed:@"timeaxis_line"];
        [self.contentView addSubview:lineImage];
        
        timeImage = [UIImageView new];
        timeImage.image = [UIImage imageNamed:@"timeaxis_time"];
        [self.contentView addSubview:timeImage];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = UIColorHex(0x333333);
        self.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:18];
        [self.contentView addSubview:self.titleLabel];
        
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@20);
            make.width.equalTo(@3);
            make.height.equalTo(@45);
        }];
        
        [timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-9));
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.centerX.mas_equalTo(lineImage.mas_centerX);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineImage).offset(15);
            make.bottom.equalTo(@(-5));
        }];
    }
    return self;
}

@end
