//
//  MNFloatToolView.h
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNFloatToolViewDelegete;

@interface MNFloatToolView : UIView

@property (nonatomic,weak) id<MNFloatToolViewDelegete> delegate;

- (void)addToView:(UIView*)view;

@end

@protocol MNFloatToolViewDelegete <NSObject>

- (void)didClickToolViewItem:(NSInteger)itemIndex;

@end
