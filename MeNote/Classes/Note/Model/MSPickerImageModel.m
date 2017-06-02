//
//  MSPickerImageModel.m
//  MeNote
//
//  Created by luoyan on 2017/6/2.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSPickerImageModel.h"
#import "NSString+Size.h"

@implementation MSPickerImageModel

+ (void)removeAndUpdateImageObj:(NSRange)range array:(NSMutableArray*)imageObjs
{
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    for (int i = 0; i < imageObjs.count; i++) {
        MSPickerImageModel *imageObj = [imageObjs objectAtIndex:i];
        if (imageObj.imageIndex >= range.location && imageObj.imageIndex < range.location+range.length) {
            [indexSet addIndex:i];
        } else {
            //更新所有对象的imageIndex
            if (imageObj.imageIndex >= range.location+range.length) {
                imageObj.imageIndex = imageObj.imageIndex - range.length;
                NSLog(@"imageObj.imageIndex = %zd",imageObj.imageIndex);
            }
        }
    }
    [imageObjs removeObjectsAtIndexes:indexSet];
}

+ (void)updateImageObj:(NSRange)range array:(NSMutableArray*)imageObjs
{
    for (int i = 0; i < imageObjs.count; i++) {
        MSPickerImageModel *imageObj = [imageObjs objectAtIndex:i];
        //更新所有对象的imageIndex
        if (imageObj.imageIndex >= range.location) {
            imageObj.imageIndex = imageObj.imageIndex + range.length;
            NSLog(@"imageObj.imageIndex = %zd",imageObj.imageIndex);
        }
    }
}

+ (void)updateImageObjTouchDeleteRect:(NSAttributedString*)attributeString array:(NSMutableArray*)imageObjs
{
    NSInteger lastIndex = 0;
    CGFloat   lastHeight = 15;
    CGFloat   lastImageHeight = 0;
    for (int i = 0; i < imageObjs.count; i++) {
        MSPickerImageModel *imageObj = [imageObjs objectAtIndex:i];
        NSInteger currentIndex = imageObj.imageIndex;
        NSAttributedString *currentString = [attributeString attributedSubstringFromRange:NSMakeRange(lastIndex, currentIndex-lastIndex)];
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: kFontPingFangRegularSize(16),
                                     NSParagraphStyleAttributeName: paragraph};
        CGSize size = [currentString.string boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX)
                                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                                      attributes:attributes
                                                         context:nil].size;
        CGFloat imageParagraphStyle = 8;
        if (i == 0) {
            lastHeight = lastHeight + size.height + imageParagraphStyle;
        } else {
            lastHeight = lastHeight + size.height + imageParagraphStyle*2 + lastImageHeight;
        }
        
        lastIndex = imageObj.imageIndex;
        lastImageHeight = imageObj.imageHeight;
        imageObj.deleteTouchRect = CGRectMake(kScreenWidth - 30 - 15 , lastHeight + 10,35, 35);
        
        NSLog(@"string=%@,deleteTouchRect = %@,size = %@,lastHeight=%.f,kscreenWidth=%.f",currentString.string,NSStringFromCGRect(imageObj.deleteTouchRect),NSStringFromCGSize(size),lastHeight,kScreenWidth);
    }
}

@end
