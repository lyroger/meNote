//
//  CSErrorTips.m
//  SellHouseManager
//
//  Created by luoyan on 16/5/17.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "CSErrorTips.h"

@interface CSErrorTips()
{
    UIImageView *imageView;
    UIView *bgView;
    UIView *lineView;
    UILabel *labelTips;
    UILabel *labelSubTips;
    UILabel *labelLoading;
    UIButton *repeatActionButton;
    NSTimer *timer;
}

@end

@implementation CSErrorTips

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView
{
    self.backgroundColor = UIColorHex(0xffffff);
    
    imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"common_badnetwork"];
    [self addSubview:imageView];
    
    lineView = [UIView new];
    lineView.backgroundColor = kColorSeparatorline;
    [self addSubview:lineView];
    lineView.hidden = YES;
    
    bgView = [UIView new];
    bgView.backgroundColor = kColorWhite;
    [self addSubview:bgView];
    bgView.hidden = YES;
    
    labelTips = [UILabel new];
    labelTips.font = kLineTitleTextFont;//15
    labelTips.textColor = kFontBlackColor;
    labelTips.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelTips];
    
    labelLoading = [UILabel new];
    labelLoading.text = @"...";
    labelLoading.textColor = kFontBlackColor;
    [self addSubview:labelLoading];
    
    labelSubTips = [UILabel new];
    labelSubTips.font = kTextFont;//14
    labelSubTips.textColor = kFontGrayColor;
    labelSubTips.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelSubTips];
    
    repeatActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    repeatActionButton.layer.cornerRadius = 5;
    repeatActionButton.layer.borderColor = kSplitLineColor.CGColor;
    repeatActionButton.layer.borderWidth = 1;
    repeatActionButton.layer.masksToBounds = YES;
    [repeatActionButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xffffff)] forState:UIControlStateNormal];
    [repeatActionButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xdddddd)] forState:UIControlStateHighlighted];
    [repeatActionButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [repeatActionButton setTitleColor:kFontGrayColor forState:UIControlStateNormal];
    repeatActionButton.titleLabel.font = kLineTitleTextFont;
    [repeatActionButton addTarget:self action:@selector(repearLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:repeatActionButton];
    
    CGFloat imageWidth = 100*ScreenMutiple6;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-50);
    }];
    
    [labelTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
    }];
    
    [labelLoading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelTips.mas_right);
        make.centerY.mas_equalTo(labelTips.mas_centerY);
        make.height.mas_equalTo(labelTips.mas_height);
        make.width.mas_equalTo(40);
    }];
    
    [labelSubTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(25);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(labelTips.mas_bottom).mas_offset(5);
    }];
    
    [repeatActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(imageView.mas_width);
        make.height.mas_equalTo(36);
        make.top.mas_equalTo(labelSubTips.mas_bottom).mas_offset(15);
    }];
}

- (void)reloadTips:(NSString*)tips subTips:(NSString*)subTips withType:(ErrorTipsType)type
{
    [self stopTimer];
    if (type == ErrorTipsType_BadNetWork || type == ErrorTipsType_ServerError) {
        labelTips.text = tips;
        labelSubTips.text = subTips;
        labelSubTips.hidden = NO;
        repeatActionButton.hidden = NO;
        CGFloat imageWidth = 100*ScreenMutiple6;
        if (type == ErrorTipsType_BadNetWork) {
            imageView.image = [UIImage imageNamed:@"common_badnetwork"];
            [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth-15));
            }];
        } else {
            imageView.image = [UIImage imageNamed:@"icon_servererror"];
            [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
            }];
        }
        
        
        [labelTips mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
        }];
        
        [labelSubTips mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labelTips.mas_bottom).mas_offset(0);
        }];
        
        [repeatActionButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labelSubTips.mas_bottom).mas_offset(15);
        }];
    } else if (type == ErrorTipsType_NoData || type == ErrorTipsType_NoCustomerData) {
        labelSubTips.hidden = YES;
        repeatActionButton.hidden = YES;
        labelTips.text = tips;
        if (type == ErrorTipsType_NoCustomerData) {
            imageView.image = [UIImage imageNamed:@"common_nocustomer_bg"];
        } else {
            imageView.image = [UIImage imageNamed:@"icon_nodata"];
        }
        CGFloat imageWidth = 100*ScreenMutiple6;
        
        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
        }];
        
        [labelTips mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
        }];
    } else if (type == ErrorTipsType_NoDataLeftTop) {
        self.backgroundColor = kPageBackgroundColor;
        repeatActionButton.hidden = YES;
        imageView.hidden = YES;
        
        bgView.hidden = NO;
        lineView.hidden = NO;
        
        labelSubTips.hidden = NO;
        labelTips.text = tips;
        labelSubTips.text = subTips;
        
        labelTips.font = kFontSize(16);
        labelTips.textColor = kColorDarkgray;
        labelTips.textAlignment = NSTextAlignmentLeft;
        labelSubTips.font = kFontSize(14);
        labelSubTips.textColor = kFontGrayColor;
        labelSubTips.textAlignment = NSTextAlignmentLeft;
        
        [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.mas_equalTo(@0);
            if ([NSString isNull:subTips]) {
                make.bottom.equalTo(labelTips.mas_bottom).offset(15);
            }else{
                make.bottom.equalTo(labelSubTips.mas_bottom).offset(15);
            }
        }];
        
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.top.equalTo(bgView.mas_bottom);
        }];
        
        [labelTips mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@15);
            make.left.mas_equalTo(@15);
        }];
        
        [labelSubTips mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labelTips.mas_bottom).offset(0);
            make.left.mas_equalTo(@16);
        }];
    } else if (type == ErrorTipsType_Loading) {
        labelSubTips.hidden = YES;
        repeatActionButton.hidden = YES;
        labelLoading.hidden = NO;
        labelTips.text = @"加载中";
        imageView.image = [UIImage imageNamed:@"loading_logo"];
        CGFloat imageWidth = 80*ScreenMutiple6;
        
        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
        }];
        
        [labelTips mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
        }];

        if (!timer) {
            timer = [NSTimer timerWithTimeInterval:0.4
                                            target:self
                                          selector:@selector(timerTick:)
                                          userInfo:nil
                                           repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }
        [timer fire];
    }
}

- (void)hideTipsView
{
    self.hidden = YES;
    [self stopTimer];
}

- (void)stopTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    labelLoading.hidden = YES;
}

- (void)timerTick:(NSTimer*)timer
{
    if ([labelLoading.text isEqualToString:@"."]) {
        labelLoading.text = @"..";
    } else if ([labelLoading.text isEqualToString:@".."]) {
        labelLoading.text = @"...";
    } else if ([labelLoading.text isEqualToString:@"..."]) {
        labelLoading.text = @".";
    }
}

- (void)repearLoadAction:(UIButton*)button
{
    if (self.repeatLoadBlock) {
        self.repeatLoadBlock();
    }
}

- (void)dealloc
{
    NSLog(@"dealloc %@ ",[self class]);
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
