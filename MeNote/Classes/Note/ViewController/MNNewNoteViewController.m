//
//  MNNewNoteViewController.m
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNNewNoteViewController.h"
#import "MNSubTitleView.h"

@interface MNNewNoteViewController ()


@property (nonatomic, strong) UITextView *editTextView;

@end

@implementation MNNewNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (void)loadSubView
{
    //导航栏左边按钮
    [self leftBarButtonWithName:nil image:[UIImage imageNamed:@"icon_close"] target:self action:@selector(closeNewNoteView:)];
    
    [self rightBarButton];
    
    [self titleView];
    
    [self loadTextView];
}

- (void)titleView
{
    MNSubTitleView *subTitleView = [[MNSubTitleView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    subTitleView.title = @"2017年04月26日";
    subTitleView.subTitle = @"星期日";
    self.navigationItem.titleView = subTitleView;
    
}

- (void)rightBarButtonAction:(UIButton*)button
{
    if (button.tag == 10) {
        //添加图片
    } else if (button.tag == 11) {
        //完成
    }
}

- (void)loadTextView
{
    if (!_editTextView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
        [self.view addSubview:view];
        
        _editTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _editTextView.textColor = UIColorHex(0x4A4A4A);
        _editTextView.font = kFontPingFangRegularSize(16);
        _editTextView.tintColor = UIColorHex(0x6dffd0);
        _editTextView.textContainerInset = UIEdgeInsetsMake(15, 10, 10, 10);
        [self.view addSubview:_editTextView];
    }
}

- (void)closeNewNoteView:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButton
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"icon_save_on"] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"icon_save_off"] forState:UIControlStateDisabled];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:kFontPingFangRegularSize(14)];
    doneButton.frame = CGRectMake(0, 0, 60, 36);
    doneButton.tag = 10;
    [doneButton setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    [doneButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItme = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"icon_image"] forState:UIControlStateNormal];
    imageButton.frame = CGRectMake(0, 0, 24, 24);
    imageButton.tag = 11;
    [imageButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *imageItme = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,doneItme,imageItme];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
