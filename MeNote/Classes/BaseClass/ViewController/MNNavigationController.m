//
//  SHMNavigationController.m
//  SellHouseManager
//
//  Created by luoyan on 16/5/3.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "MNNavigationController.h"

@interface MNNavigationController ()

@end

@implementation MNNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//手势返回
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    /*
    //自定了leftBarButton后能使用手势返回
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
     */
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
