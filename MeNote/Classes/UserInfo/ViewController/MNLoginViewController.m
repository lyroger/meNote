//
//  MNLoginViewController.m
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNLoginViewController.h"

@interface MNLoginViewController ()

@property (nonatomic, strong) UIButton *btnLogin;

@end

@implementation MNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadSubView
{
    self.view.backgroundColor = kFontDarkgrayColor;
    
    self.btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnLogin.layer.cornerRadius = 4;
    self.btnLogin.layer.masksToBounds = 1;
    
    self.btnLogin.backgroundColor = kColorBlue;
    [self.btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.btnLogin addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLogin];
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@44);
    }];
}

- (void)loginAction:(UIButton*)button
{
    self.loginCompleteBlock(YES);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
