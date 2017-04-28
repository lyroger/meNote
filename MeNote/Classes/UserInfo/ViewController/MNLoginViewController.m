//
//  MNLoginViewController.m
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNLoginViewController.h"
#import "MNForgetPwdViewController.h"
#import "MNRegisterViewController.h"
#import "MNBottomTitleButton.h"

@interface MNLoginViewController ()<UITextFieldDelegate>
{
    UIControl *loginContentView;
    UIView *accountInputContent;
    UITextField *userTextField;
    UITextField *pwdTextField;
    
    UIView *loginActionContentView;
    UIButton *loginButton;
    
    UIView *loginOtherContentView;
}

@property (nonatomic, strong) UIButton *btnLogin;

@end

@implementation MNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    [self notificationRegister];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadSubView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载页面布局的父容器
    loginContentView = [UIControl new];
    loginContentView.frame = self.view.bounds;
    [loginContentView addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginContentView];
    
    //加载logo
    UIImageView *logoImage = [[UIImageView alloc] init];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    logoImage.image = [UIImage imageNamed:@"login_icon_logo"];
    [loginContentView addSubview:logoImage];
    
    //加载账号密码输入框
    accountInputContent = [UIView new];
    accountInputContent.backgroundColor = [UIColor whiteColor];
    [loginContentView addSubview:accountInputContent];
    
    UIView *accountLine = [UIView new];
    accountLine.backgroundColor = UIColorHex(0xE5E5E5);
    [accountInputContent addSubview:accountLine];
    
    UIView *pwdLine = [UIView new];
    pwdLine.backgroundColor = UIColorHex(0xE5E5E5);
    [accountInputContent addSubview:pwdLine];
    
    UIImageView *accountImage = [UIImageView new];
    accountImage.image = [UIImage imageNamed:@"login_icon_user"];
    [accountInputContent addSubview:accountImage];
    
    UIImageView *pwdImage = [UIImageView new];
    pwdImage.image = [UIImage imageNamed:@"login_icon_password"];
    [accountInputContent addSubview:pwdImage];
    
    NSString *username = [MNUserInfo shareUserInfo].userAcount;
    userTextField = [UITextField new];
    userTextField.placeholder = @"输入手机号";
    userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userTextField.returnKeyType = UIReturnKeyNext;
    userTextField.delegate = self;
    userTextField.text = username;
    userTextField.tintColor = UIColorHex(0x6dffd0);
    userTextField.font = kFontPingFangRegularSize(16);
    userTextField.textColor = UIColorHex(0x666666);
    [accountInputContent addSubview:userTextField];
    
    
    NSString *password = [[MNUserInfo shareUserInfo] getPassword];
    pwdTextField = [UITextField new];
    pwdTextField.placeholder = @"输入密码";
    pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTextField.secureTextEntry = YES;
    pwdTextField.returnKeyType = UIReturnKeyDone;
    pwdTextField.delegate = self;
    pwdTextField.text = password;
    pwdTextField.tintColor = UIColorHex(0x6dffd0);
    pwdTextField.font = kFontPingFangRegularSize(16);
    pwdTextField.textColor = UIColorHex(0x666666);
    [accountInputContent addSubview:pwdTextField];
    
    
    //加载登录按钮
    loginActionContentView = [UIView new];
    loginActionContentView.backgroundColor = self.view.backgroundColor;
    [loginContentView addSubview:loginActionContentView];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_icon_off"] forState:UIControlStateDisabled];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_icon_on"] forState:UIControlStateNormal];
    
    loginButton.layer.cornerRadius = 24;
    loginButton.layer.borderColor = [UIColor clearColor].CGColor;
    loginButton.layer.borderWidth = 1;
    loginButton.layer.masksToBounds = YES;
    
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.enabled = NO;
    loginButton.titleLabel.font = kFontPingFangMediumSize(18);
    [loginActionContentView addSubview:loginButton];
    
    if (username.length > 0 && password.length > 0) {
        loginButton.enabled = YES;
    } else {
        loginButton.enabled = NO;
    }
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = [UIColor clearColor];
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [registerButton setTitleColor:UIColorHex(0x38DDC2) forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    registerButton.titleLabel.font = kFontPingFangMediumSize(16);
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [loginActionContentView addSubview:registerButton];
    
    
    UIButton *forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotPasswordButton.backgroundColor = [UIColor clearColor];
    forgotPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgotPasswordButton setTitleColor:UIColorHex(0x888888) forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    forgotPasswordButton.titleLabel.font = kFontPingFangMediumSize(16);
    [forgotPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgotPasswordButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [loginActionContentView addSubview:forgotPasswordButton];
    
    
    loginOtherContentView = [UIView new];
    [loginContentView addSubview:loginOtherContentView];
    
    MNBottomTitleButton *weiButton = [MNBottomTitleButton new];
    [weiButton.button setBackgroundImage:[UIImage imageNamed:@"login_icon_weixin"] forState:UIControlStateNormal];
    weiButton.label.text = @"微信登录";
    [weiButton.button addTarget:self action:@selector(loginByOther:) forControlEvents:UIControlEventTouchUpInside];
    [loginOtherContentView addSubview:weiButton];
    
    MNBottomTitleButton *qqButton = [MNBottomTitleButton new];
    [qqButton.button setBackgroundImage:[UIImage imageNamed:@"login_icon_qq"] forState:UIControlStateNormal];
    qqButton.label.text = @"QQ登录";
    [qqButton.button addTarget:self action:@selector(loginByOther:) forControlEvents:UIControlEventTouchUpInside];
    [loginOtherContentView addSubview:qqButton];
    
    MNBottomTitleButton *weiboButton = [MNBottomTitleButton new];
    [weiboButton.button setBackgroundImage:[UIImage imageNamed:@"login_icon_weibo"] forState:UIControlStateNormal];
    weiboButton.label.text = @"微博登录";
    [weiboButton.button addTarget:self action:@selector(loginByOther:) forControlEvents:UIControlEventTouchUpInside];
    [loginOtherContentView addSubview:weiboButton];
    /**
     *  布局
     */
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(100*ScreenMutiple6));
        make.size.mas_equalTo(CGSizeMake(146, 36));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [accountInputContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(40));
        make.right.equalTo(@(-40));
        make.top.mas_equalTo(logoImage.mas_bottom).mas_offset(40);
        make.height.equalTo(@(140));
    }];
    
    [accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.centerY.mas_equalTo(accountInputContent.mas_centerY);
        make.height.mas_equalTo(@(1));
    }];
    
    [pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(@(1));
    }];
    
    [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12));
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(@(24));
    }];
    
    [pwdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12));
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.bottom.mas_equalTo(-24);
    }];
    
    [userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountImage.mas_right).offset(12);
        make.centerY.equalTo(accountImage).offset(2);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(-12);
    }];
    
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pwdImage.mas_right).offset(12);
        make.centerY.equalTo(pwdImage).offset(1);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(-12);
    }];
    
    //登录按钮及记住密码层
    [loginActionContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(accountInputContent.mas_bottom).offset(50);
        make.left.equalTo(accountInputContent);
        make.right.equalTo(accountInputContent);
        make.height.mas_equalTo(90);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-11);
        make.height.mas_equalTo(20);
    }];
    
    [forgotPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-11);
        make.height.mas_equalTo(20);
    }];
    
    [loginOtherContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.left.equalTo(accountInputContent);
        make.right.equalTo(accountInputContent);
        make.height.equalTo(@84);
    }];
    
    //第三方登录
    [weiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(@0);
        make.width.equalTo(@58);
    }];
    
    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.centerX.equalTo(loginOtherContentView.mas_centerX);
        make.width.equalTo(weiButton);
    }];
    
    [weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(@0);
        make.width.equalTo(weiButton);
    }];
}

/**
 *   隐藏键盘
 */
- (void)hideKeyboard
{
    [userTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
}

- (void)loginAction:(UIButton*)button
{
    [self hideKeyboard];
    NSString *username = [userTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [pwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.loginCompleteBlock) {
        self.loginCompleteBlock(YES);
    }
    
    if (username.length > 0 && password.length > 0) {
        DLog(@"账号密码格式正确");
        [MNUserInfo loginWithLoginId:username password:password networkHUD:NetworkHUDLockScreenAndError target:self success:^(StatusModel *data) {
            if (data.code == 0) {
                //登录成功
                MNUserInfo *userInfo = data.data;
                //登录后的lastCityId应该取cityId的值
                userInfo.lastCityId = userInfo.cityId;
                userInfo.lastCityName = userInfo.cityName;
                userInfo.userAcount = username;//账号信息
                [[MNUserInfo shareUserInfo] setUserInfo:userInfo];
                
                // 放在注册推送信息接口会调用保存。
                //                [[SHMUserInfo getUsingLKDBHelper] insertToDB:userInfo callback:^(BOOL result) {
                //                    NSLog(@"result = %zd",result);
                //                }];
                
                
                
                [[NSUserDefaults standardUserDefaults] setObject:userInfo.userAcount forKey:kLastUserAcount];
                
                if (self.loginCompleteBlock) {
                    self.loginCompleteBlock(YES);
                }
            }
        }];
    } else {
        DLog(@"请输入8位长度的密码");
        
    }
}

//第三方登录
- (void)loginByOther:(UIButton*)button
{
    if (button.tag == 100) {
        //微信
    } else if (button.tag == 101) {
        //qq
    } else if (button.tag == 102) {
        //微博
        
    }
        
}

- (void)registerUserInfo
{
    MNRegisterViewController *registerVC = [[MNRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)forgetPassword
{
    MNForgetPwdViewController *vc = [[MNForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:pwdTextField]) {
        [self loginAction:nil];
    } else if ([textField isEqual:userTextField]) {
        [pwdTextField becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldTextDidChange:(NSNotification *)note
{
    NSString *username = [userTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [pwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (username.length > 0 && password.length > 0) {
        loginButton.enabled = YES;
    } else {
        loginButton.enabled = NO;
    }
}

#pragma mark - Keyboard Methods
- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHidden:(NSNotification *)note
{
    [UIView animateWithDuration:0.3f animations:^{
        loginContentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)keyboardWillShown:(NSNotification *)note
{
    CGFloat height = 0;
    NSDictionary *info = [note userInfo];
    NSInteger keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    height = accountInputContent.mj_origin.y+pwdTextField.mj_origin.y+pwdTextField.mj_h;
    
    CGFloat offsetY;
    
    if (loginContentView.frame.size.height - keyboardHeight <= height)
        offsetY = height - loginContentView.size.height + keyboardHeight + 10;
    else
        return;
    
    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double duration = [number doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        loginContentView.frame = CGRectMake(0, -offsetY, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
