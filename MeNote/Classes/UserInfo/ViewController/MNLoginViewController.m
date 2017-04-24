//
//  MNLoginViewController.m
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNLoginViewController.h"
#import "MNForgetPwdViewController.h"

@interface MNLoginViewController ()<UITextFieldDelegate>
{
    UIControl *loginContentView;
    UIView *accountInputContent;
    UITextField *userTextField;
    UITextField *pwdTextField;
    
    UIView *loginActionContentView;
    UIButton *loginButton;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    logoImage.image = [UIImage imageNamed:@"icon_login_logo"];
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
    userTextField.placeholder = @"账号";
    userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userTextField.returnKeyType = UIReturnKeyNext;
    userTextField.delegate = self;
    userTextField.text = username;
    userTextField.font = kTextFont;
    userTextField.textColor = UIColorHex(0x666666);
    [accountInputContent addSubview:userTextField];
    
    
    NSString *password = [[MNUserInfo shareUserInfo] getPassword];
    pwdTextField = [UITextField new];
    pwdTextField.placeholder = @"密码";
    pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTextField.secureTextEntry = YES;
    pwdTextField.returnKeyType = UIReturnKeyDone;
    pwdTextField.delegate = self;
    pwdTextField.text = password;
    pwdTextField.font = kTextFont;
    pwdTextField.textColor = UIColorHex(0x666666);
    [accountInputContent addSubview:pwdTextField];
    
    
    //加载登录按钮
    loginActionContentView = [UIView new];
    loginActionContentView.backgroundColor = self.view.backgroundColor;
    [loginContentView addSubview:loginActionContentView];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundImage:[UIImage imageWithColor:UIColorHex_Alpha(0x02B0F0, 0.39)] forState:UIControlStateDisabled];
    [loginButton setBackgroundImage:[UIImage imageWithColor:UIColorHex_Alpha(0x02B0F0, 1)] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageWithColor:UIColorHex_Alpha(0x02B0F0, 1)] forState:UIControlStateSelected];
    
    loginButton.layer.cornerRadius = 22;
    loginButton.layer.borderColor = [UIColor clearColor].CGColor;
    loginButton.layer.borderWidth = 1;
    loginButton.layer.masksToBounds = YES;
    
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.enabled = NO;
    loginButton.titleLabel.font = kFontSize(18);
    [loginActionContentView addSubview:loginButton];
    
    if (username.length > 0 && password.length > 0) {
        loginButton.enabled = YES;
    } else {
        loginButton.enabled = NO;
    }
    
    
    UIButton *forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotPasswordButton.backgroundColor = [UIColor clearColor];
    forgotPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgotPasswordButton setTitleColor:UIColorHex(0xCCCCCC) forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    forgotPasswordButton.titleLabel.font = kTextFont;
    [forgotPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgotPasswordButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [loginActionContentView addSubview:forgotPasswordButton];
    
    /**
     *  布局
     */
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(75*ScreenMutiple6));
        make.size.mas_equalTo(CGSizeMake(120, 125));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [accountInputContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.right.equalTo(@(-15));
        make.top.mas_equalTo(logoImage.mas_bottom).mas_offset(40*ScreenMutiple6);
        make.height.equalTo(@(100));
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
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.top.mas_equalTo(17);
    }];
    
    [pwdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12));
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.bottom.mas_equalTo(-16);
    }];
    
    [userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountImage.mas_right).offset(12);
        make.top.mas_equalTo(7);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-12);
    }];
    
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pwdImage.mas_right).offset(12);
        make.bottom.mas_equalTo(-6);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-12);
    }];
    
    //登录按钮及记住密码层
    [loginActionContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(accountInputContent.mas_bottom).offset(40);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(90);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [forgotPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-11);
        make.height.mas_equalTo(20);
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
@end
