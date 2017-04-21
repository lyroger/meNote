//
//  SHMBaseViewController.m
//  SellHouseManager
//
//  Created by luoyan on 16/5/3.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "MNBaseViewController.h"

@interface MNBaseViewController ()<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer  *_tap; // 添加手势用于点击空白处收回键盘
    MBProgressHUD *HUD;
    CSErrorTips *tipsView;
}

@end

@implementation MNBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kPageBackgroundColor;
    self.tabBarController.tabBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.navigationController.viewControllers.firstObject != self) {
        [self configBackBarButton];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleDefault)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    NSLog(@"%@,%@",NSStringFromClass([self class]),self.title);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([self isTabbarRoot]) {
        self.hidesBottomBarWhenPushed = NO;
    } else {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    if (!self.navigationController) {
        [self viewWillPop];
    }
}

- (void)viewWillPop
{
    [tipsView hideTipsView];
    tipsView = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    //记录访问页面离开
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isNavRoot
{
    return self.navigationController.viewControllers.firstObject == self;
}

- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type  superView:(UIView*)superView frame:(CGRect)frame
{
    if (type == ErrorTipsType_BadNetWork) {
        [self showTipsByBadNetWorkWithFrame:frame superView:superView];
    } else if (type == ErrorTipsType_NoData || type == ErrorTipsType_NoCustomerData || type == ErrorTipsType_NoDataLeftTop) {
        [self showNoDataTips:tips subTips:subTips type:type withFrame:frame superView:superView];
    } else if (type == ErrorTipsType_Loading) {
        [self showLoadingTipsWithFrame:frame superView:superView];
    } else if (type == ErrorTipsType_ServerError) {
        [self showTipsBySeverErrorWithFrame:frame superView:superView];
    }
    return tipsView;
}

- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type frame:(CGRect)frame
{
    return [self showLoadTips:tips subTips:subTips type:type superView:self.view frame:frame];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type superView:(UIView*)superView
{
    if (superView && (![superView isEqual:self.view])) {
        [superView addSubview:tipsView];
    }
    return [self showLoadTips:tips subTips:subTips type:type superView:superView frame:superView.bounds];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type
{
    return [self showLoadTips:tips subTips:subTips type:type superView:self.view frame:self.view.bounds];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type superView:(UIView*)superView frame:(CGRect)frame
{
    return [self showLoadTips:tips subTips:nil type:type superView:superView frame:frame];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type frame:(CGRect)frame
{
    return [self showLoadTips:tips type:type superView:self.view frame:frame];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type superView:(UIView*)superView
{
    if (superView && (![superView isEqual:self.view])) {
        [superView addSubview:tipsView];
    }
    return [self showLoadTips:tips type:type superView:superView frame:superView.bounds];
}

- (CSErrorTips*)showLoadTips:(NSString*)tips type:(ErrorTipsType)type
{
    return [self showLoadTips:tips type:type superView:self.view frame:self.view.bounds];
}

- (CSErrorTips*)showLoadType:(ErrorTipsType)type
{
    return [self showLoadTips:nil type:type superView:self.view frame:self.view.bounds];
}

//网络错误
- (void)showTipsByBadNetWorkWithFrame:(CGRect)frame superView:(UIView*)superView
{
    if (!tipsView) {
        tipsView = [[CSErrorTips alloc] initWithFrame:frame];
        [superView addSubview:tipsView];
    }
    tipsView.frame = frame;
    tipsView.hidden = NO;
    [self.view bringSubviewToFront:tipsView];
    [tipsView reloadTips:@"网络连接错误" subTips:@"请检查您的网络设置" withType:ErrorTipsType_BadNetWork];
    @weakify(self);
    tipsView.repeatLoadBlock = ^(){
        @strongify(self);
        [self needReloadData];
    };
}

//服务器错误
- (void)showTipsBySeverErrorWithFrame:(CGRect)frame superView:(UIView*)superView
{
    if (!tipsView) {
        tipsView = [[CSErrorTips alloc] initWithFrame:frame];
        [superView addSubview:tipsView];
    }
    tipsView.frame = frame;
    tipsView.hidden = NO;
    [self.view bringSubviewToFront:tipsView];
    [tipsView reloadTips:@"服务器错误" subTips:@"尝试重新加载一下吧" withType:ErrorTipsType_ServerError];
    @weakify(self);
    tipsView.repeatLoadBlock = ^(){
        @strongify(self);
        [self needReloadData];
    };
}

//页面加载数据中
- (void)showLoadingTipsWithFrame:(CGRect)frame superView:(UIView*)superView
{
    if (!tipsView) {
        tipsView = [[CSErrorTips alloc] initWithFrame:frame];
        [superView addSubview:tipsView];
    }
    tipsView.hidden = NO;
    [self.view bringSubviewToFront:tipsView];
    [tipsView reloadTips:nil subTips:nil withType:ErrorTipsType_Loading];
}

//暂无数据
- (void)showNoDataTips:(NSString*)tips subTips:(NSString*)subTips type:(ErrorTipsType)type withFrame:(CGRect)frame superView:(UIView*)superView
{
    if (!tipsView) {
        tipsView = [[CSErrorTips alloc] initWithFrame:frame];
        [superView addSubview:tipsView];
    }
    tipsView.frame = frame;
    tipsView.hidden = NO;
    [self.view bringSubviewToFront:tipsView];
    [tipsView reloadTips:tips subTips:subTips withType:type];
}

- (void)hideTipsView
{
    [tipsView hideTipsView];
}

- (BOOL)isTipsViewHidden
{
    if (!tipsView) {
        return YES;
    }
    
    return tipsView.hidden;
}

- (void)needReloadData
{
    
}

- (void)textFieldReturn
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _tap.cancelsTouchesInView = NO; // 当前视图识别手势后把事件传递出后
        _tap.delegate = self;
        [self.view addGestureRecognizer:_tap];
    }
}

- (BOOL)isTabbarRoot
{
    for (UINavigationController* nc in self.tabBarController.viewControllers) {
        if (nc.viewControllers.firstObject == self) {
            return YES;
        }
    }
    return NO;
}

#pragma mark- 网络加载视图

/// LoadingAndRefreshViewDelegate
- (void)reflashClick
{
    [self loadData];
}
// 此方法用作加载失败后，重新加载使用，勿删
- (void)loadData
{
    
}

#pragma mark- 网络操作的添加和释放

- (void)addNet:(NSURLSessionDataTask *)net
{
    if (!_networkOperations)
    {
        _networkOperations = [[NSMutableArray alloc] init];
    }
    
    [_networkOperations addObject:net];
}

- (void)releaseNet
{
    for (NSURLSessionDataTask *net in _networkOperations)
    {
        if ([net isKindOfClass:[NSURLSessionDataTask class]]) {
            [net cancel];
        }
    }
}

#pragma mark - 导航栏按钮

// 设置导航栏右按钮
- (void)rightBarButtonWithName:(NSString *)name
                  normalImgName:(NSString *)normalImgName
               highlightImgName:(NSString *)highlightImgName
                         target:(id)target
                         action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (normalImgName && ![normalImgName isEqualToString:@""]) {
        UIImage *image = [UIImage imageNamed:normalImgName];
        [btn setImage:image forState:UIControlStateNormal];
        
        UIImage *imageSelected = [UIImage imageNamed:highlightImgName];
        if (imageSelected) {
            [btn setImage:imageSelected forState:UIControlStateHighlighted];
        }
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    } else {
        btn.frame=CGRectMake(0, 0, 60, 30);
    }
    
    if (name && ![name isEqualToString:@""])
    {
        [btn setTitle:name forState:UIControlStateNormal];
        btn.titleLabel.font = kFontSize16;
        [btn setTitleColor:kMainColor forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHex_Alpha(0x02b0f0,0.3) forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColorHex_Alpha(0x02b0f0,0.3) forState:UIControlStateDisabled];
        CGFloat nameWidth = [name widthWithFont:btn.titleLabel.font constrainedToHeight:CGFLOAT_MAX];
        btn.frame=CGRectMake(0, 0, nameWidth+13, 30);
    }
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)rightBarRoundedBtnNames:(NSArray *)names
                         target:(id)target
                         action:(SEL)action
{
    NSMutableArray *barButtonItems = [NSMutableArray array];
    for (NSString *name in names) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:name forState:UIControlStateNormal];
        btn.titleLabel.font = kFontSize14;
        [btn setTitleColor:kMainColor forState:UIControlStateNormal];
        CGFloat nameWidth = [name widthWithFont:btn.titleLabel.font constrainedToHeight:CGFLOAT_MAX];
        if (name.length == 1) {
            nameWidth = 4;
        }
        btn.frame=CGRectMake(0, 0, nameWidth+18, 26);
        btn.tag = [names indexOfObject:name];
        btn.layer.borderWidth = 1.0;
        btn.layer.cornerRadius = btn.height/2.0;
        btn.layer.borderColor = kMainColor.CGColor;
        
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [barButtonItems insertObject:item atIndex:0];
    }
    self.navigationItem.rightBarButtonItems = barButtonItems;
}

- (void)leftBarButtonWithName:(NSString *)name image:(UIImage *)image target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *negativeSpacer;
    if (image) {
        
        [btn setImage:image forState:UIControlStateNormal];
        
        if (ISIOS7) {
            btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        } else {
            btn.frame = CGRectMake(0, 0, image.size.width + 20, image.size.height);
        }
    } else {
        btn.frame=CGRectMake(0, 0, 70, 30);
        negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -26;
    }
    
    if (name && ![name isEqualToString:@""])
    {
        [btn setTitle:name forState:UIControlStateNormal];
        btn.titleLabel.font = kFontSize(16);
        [btn setTitleColor:kMainColor forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHex_Alpha(0x02b0f0,0.3) forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColorHex_Alpha(0x02b0f0,0.3) forState:UIControlStateDisabled];
    } else {
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    
    if (ISIOS7)
    {
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (negativeSpacer) {
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,item];
    } else {
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)configBackBarButton
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitleColor:kMainColor forState:UIControlStateNormal];
    [bt setTitleColor:UIColorHex_Alpha(0x02b0f0,0.3) forState:UIControlStateHighlighted];
    [bt setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
//    [bt setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateHighlighted];
    bt.frame = CGRectMake(0, 0, 30, 30);
    bt.titleLabel.font = kFontSize16;
    [bt setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 6)];
    [bt addTarget:self action:@selector(backToSuperView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bt];
}

- (void)backToSuperView
{
    if (![self navigationShouldPopOnBackButton]) {
        return;
    }
    if (self.navigationController.viewControllers.firstObject == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (self.presentedViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)tapped:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationItem.titleView endEditing:YES];
}

- (BOOL)navigationShouldPopOnBackButton
{
    return YES;
}

- (NSString *)navigationItemBackBarButtonTitle
{
    return @"";
}

- (void)dealloc
{
    DLog(@"%@释放了",NSStringFromClass([self class]));
    if (_tap) {
        [self.view removeGestureRecognizer:_tap];
        [_tap removeTarget:nil action:nil];
        _tap = nil;
    }

    [self releaseNet];
}

@end
