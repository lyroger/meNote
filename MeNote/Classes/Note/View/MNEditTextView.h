//
//  MNEditTextView.h
//  MeNote
//
//  Created by luoyan on 2017/5/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNEditTextViewDelegate;
@interface MNEditTextView : UITextView

@property (nonatomic,weak) id<MNEditTextViewDelegate> touchDelegate;

- (void)addTapEvent;
@end


@protocol MNEditTextViewDelegate <NSObject>

- (void)didTapEditTextViewEvent:(MNEditTextView*)view touchPoint:(CGPoint)point;

@end
