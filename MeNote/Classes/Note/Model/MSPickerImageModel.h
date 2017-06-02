//
//  MSPickerImageModel.h
//  MeNote
//
//  Created by luoyan on 2017/6/2.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"

@interface MSPickerImageModel : BaseModel

@property (nonatomic, assign) CGFloat   imageHeight;
@property (nonatomic, strong) UIImage   *image;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, copy)   NSString  *imageURL;
@property (nonatomic, assign) CGRect    deleteTouchRect;

+ (void)removeAndUpdateImageObj:(NSRange)range array:(NSMutableArray*)imageObjs;
+ (void)updateImageObj:(NSRange)range array:(NSMutableArray*)imageObjs;
+ (void)updateImageObjTouchDeleteRect:(NSAttributedString*)attributeString array:(NSMutableArray*)imageObjs;
@end
