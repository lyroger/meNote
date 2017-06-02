//
//  MNNoteListModel.h
//  MeNote
//
//  Created by 罗琰 on 2017/4/24.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"

@interface MNNoteListModel : BaseModel

@property (nonatomic, copy)     NSString *noteDate;
@property (nonatomic, copy)     NSString *noteDes;
@property (nonatomic, strong)   NSArray  *noteImages;

@end
