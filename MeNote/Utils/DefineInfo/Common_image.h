//  功能描述：常用图片预定义
#ifndef HKMember_Image_h
#define HKMember_Image_h


//图片
#define kImageWithName(text) [UIImage imageNamed:text]

//拉伸图片边框处理
#define kImageWithUIEdge(text) [[UIImage imageNamed:text] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch]

//纯色图片
#define ImageWithColor(color) [[UIImage imageWithColor:color andSize:CGSizeMake(10, 10)] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch]


#define kdefault_header     @""
#define kdefault_group_header  @""

#define MAX_SIZE 120 //　图片最大显示大小


#endif
