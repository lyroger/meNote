//
//  MNEditTextView.m
//  MeNote
//
//  Created by luoyan on 2017/5/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNEditTextView.h"

@interface MNEditTextView()
{
    
}

@property (nonatomic, strong) UIView *hitTestView;

@end

@implementation MNEditTextView

- (void)addTapEvent
{
//    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[NSClassFromString(@"_UITextContainerView") class]]) {
//            NSLog(@"uitextcontainerview");
//            self.hitTestView = obj;
//            obj.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextView:)];
//            [obj addGestureRecognizer:tap];
//        }
//    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"point = %@",NSStringFromCGPoint(point));
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint userPoint = [self.hitTestView convertPoint:point fromView:self];
    if ([self.hitTestView pointInside:userPoint withEvent:event]) {
//    CGFloat fraction = 0;
//    NSInteger characterIndex = [self.layoutManager  characterIndexForPoint:userPoint inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:&fraction];
        
        [self enumerateAttribute];
        
        return self.hitTestView;
    }
    return result;
}

- (void)enumerateAttribute
{
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName
                                    inRange:NSMakeRange(0, self.attributedText.length)
                                    options:0
                                 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                     //检查类型是否是自定义NSTextAttachment类
                                     if (value && [value isKindOfClass:[NSTextAttachment class]]) {
                                         //替换
                                         NSLog(@"value=%@,range=%@",value,NSStringFromRange(range));
//                                         [textString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:symbol];
//                                         //增加偏移量
//                                         base += (symbol.length - 1);
                                     }
                                 }];

}

- (void)tapTextView:(UITapGestureRecognizer*)tap
{
    NSLog(@"ssfefelfjelf");
}
@end
