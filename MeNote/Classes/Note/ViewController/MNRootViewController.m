//
//  ViewController.m
//  MeNote
//
//  Created by luoyan on 2017/4/20.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNRootViewController.h"
#import "MNFloatToolView.h"

@interface MNRootViewController ()

@end

@implementation MNRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadSubView
{
    UILabel *tips = [UILabel new];
    tips.text = @"首页-心情列表页";
    tips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    MNFloatToolView *floadView = [MNFloatToolView new];
    [floadView addToView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
