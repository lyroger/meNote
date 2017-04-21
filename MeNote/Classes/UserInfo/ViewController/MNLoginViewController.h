//
//  MNLoginViewController.h
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNBaseViewController.h"

typedef void(^DidLoginComplete)(BOOL successful);

@interface MNLoginViewController : MNBaseViewController

@property (nonatomic, copy) DidLoginComplete loginCompleteBlock;

@end
