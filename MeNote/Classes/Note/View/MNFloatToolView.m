//
//  MNFloatToolView.m
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNFloatToolView.h"

#define kMainButtonWidth 50
#define kToolButtonWidth 40
#define kToolMarginWidth 10

@interface MNFloatToolView()
{
    UIButton *mainButton;
    UIButton *userButton;
    UIButton *editButton;
    UIView   *coverView;
    
    BOOL     isUnFold; //是否展开
}

@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation MNFloatToolView

- (id)init
{
    if (self == [super init]) {
        isUnFold = NO;
        coverView = [UIView new];
        coverView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        [self addSubview:coverView];

        userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [userButton setTitle:@"U" forState:UIControlStateNormal];
        userButton.frame = CGRectMake(0, 0, kToolButtonWidth, kToolButtonWidth);
        userButton.layer.cornerRadius = kToolButtonWidth/2;
        userButton.layer.masksToBounds = YES;
        userButton.layer.borderColor = [UIColor clearColor].CGColor;
        userButton.layer.borderWidth = 1;
        userButton.backgroundColor = UIColorHex(0x00c3c4);
        [self addSubview:userButton];
        
        editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setTitle:@"E" forState:UIControlStateNormal];
        editButton.frame = CGRectMake(0, 0, kToolButtonWidth, kToolButtonWidth);
        editButton.frame = CGRectMake(0, 0, kToolButtonWidth, kToolButtonWidth);
        editButton.layer.cornerRadius = kToolButtonWidth/2;
        editButton.layer.masksToBounds = YES;
        editButton.layer.borderColor = [UIColor clearColor].CGColor;
        editButton.layer.borderWidth = 1;
        editButton.backgroundColor = UIColorHex(0x00c3c4);
        [self addSubview:editButton];
        
        mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mainButton setTitle:@"M" forState:UIControlStateNormal];
        mainButton.frame = CGRectMake(0, 0, kMainButtonWidth, kMainButtonWidth);
        mainButton.layer.cornerRadius = kMainButtonWidth/2;
        mainButton.layer.borderColor = [UIColor clearColor].CGColor;
        mainButton.layer.borderWidth = 1;
        mainButton.layer.shadowOpacity = 0.5;// 阴影透明度
        mainButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;// 阴影的颜色
        mainButton.layer.shadowRadius = 3;// 阴影扩散的范围控制
        mainButton.layer.shadowOffset  = CGSizeMake(2, 2);// 阴影的范围
        mainButton.backgroundColor = UIColorHex(0x00c3c4);
        [mainButton addTarget:self action:@selector(clickMainAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mainButton];
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        self.clipsToBounds = NO;
    }
    return  self;
}

- (void)clickMainAction:(UIButton*)button
{
    CGRect userRect;
    CGRect editRect;
    if (self.center.x > self.superView.size.width/2) {
        //此时悬靠在右边
        userRect = CGRectMake(-(kToolButtonWidth*2+kToolMarginWidth*2), userButton.origin.y, userButton.size.width, userButton.size.height);
        editRect = CGRectMake(-(kToolButtonWidth+kToolMarginWidth), editButton.origin.y, editButton.size.width, editButton.size.height);
        
    } else {
        //此时悬靠在左边
        userRect = CGRectMake((kToolButtonWidth + kMainButtonWidth +kToolMarginWidth*2), userButton.origin.y, userButton.size.width, userButton.size.height);
        editRect = CGRectMake((kMainButtonWidth + kToolMarginWidth), editButton.origin.y, editButton.size.width, editButton.size.height);
    }
    
    coverView.hidden = isUnFold;
    //功能按钮向右展开
    if (!isUnFold) {
        [self removeGestureRecognizer:self.pan];
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             //展开的时候
                             mainButton.transform = CGAffineTransformMakeRotation(M_PI);
                             userButton.transform = CGAffineTransformMakeRotation(2*M_PI);
                             editButton.transform = CGAffineTransformMakeRotation(2*M_PI);
                             userButton.frame = userRect;
                             editButton.frame = editRect;
                             
                         } completion:^(BOOL finished) {
                             isUnFold = !isUnFold;
                         }];
    } else {
        [self addGestureRecognizer:self.pan];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //收起的时候
            mainButton.transform = CGAffineTransformIdentity;
            userButton.transform = CGAffineTransformIdentity;
            editButton.transform = CGAffineTransformIdentity;
            userButton.center = mainButton.center;
            editButton.center = mainButton.center;
        } completion:^(BOOL finished) {
            isUnFold = !isUnFold;
        }];
    }
}

- (void)addToView:(UIView*)view
{
    self.superView = view;
    [self.superView addSubview:self];
    self.frame = CGRectMake(self.superView.size.width-kMainButtonWidth+5, self.superView.size.height-50-kMainButtonWidth, kMainButtonWidth, kMainButtonWidth);
    
    coverView.frame = view.bounds;
    mainButton.center = CGPointMake(kMainButtonWidth/2, kMainButtonWidth/2);
    userButton.center = mainButton.center;
    editButton.center = mainButton.center;
    
    if (!self.pan) {
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handPand:)];
        [self addGestureRecognizer:self.pan];
    }
}

- (void)handPand:(UIPanGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.superView];
    if ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateBegan) {
        NSLog(@"began- %@",NSStringFromCGPoint(point));
        self.center = point;
    } else if ([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateChanged) {
        NSLog(@"changed- %@",NSStringFromCGPoint(point));
        self.center = point;
    } else {
        NSLog(@"other- %@",NSStringFromCGPoint(point));
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:8 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGFloat y = point.y;
            if (y<kMainButtonWidth/2) {
                y = kMainButtonWidth/2 + 5;
            } else if (y > self.superView.size.height-kMainButtonWidth/2) {
                y = self.superView.size.height - kMainButtonWidth/2 - 5;
            }
            
            if (point.x > self.superView.size.width/2) {
                self.center = CGPointMake(self.superView.size.width-self.size.width/2+5,y);
            } else if (point.x <= self.superView.size.width/2) {
                self.center = CGPointMake(-5+kMainButtonWidth/2, y);
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
