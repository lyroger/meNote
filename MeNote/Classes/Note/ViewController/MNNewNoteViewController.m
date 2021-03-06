//
//  MNNewNoteViewController.m
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNNewNoteViewController.h"
#import "MNSubTitleView.h"
#import "MNEditTextView.h"
#import "MSPickerImageModel.h"

@interface MNNewNoteViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MNEditTextViewDelegate>

@property (nonatomic, strong) MNEditTextView        *editTextView;
@property (nonatomic, strong) NSMutableDictionary   *mutImgDict;
@property (nonatomic, strong) NSMutableArray        *mutImgArray;
@property (nonatomic, strong) NSMutableArray        *imgURLArray;//最终确定照片URl数组
@property (nonatomic, assign) NSInteger             selectTextIndex;//textview光标位置

@property (nonatomic, strong) NSMutableArray        *imageObjs;

@end

@implementation MNNewNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (void)loadSubView
{
    //导航栏左边按钮
    [self leftBarButtonWithName:nil image:[UIImage imageNamed:@"icon_close"] target:self action:@selector(closeNewNoteView:)];
    
    [self rightBarButton];
    
    [self titleView];
    
    [self loadTextView];
    
}

- (void)titleView
{
    MNSubTitleView *subTitleView = [[MNSubTitleView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    subTitleView.title = @"2017年04月26日";
    subTitleView.subTitle = @"星期日";
    self.navigationItem.titleView = subTitleView;
    
}

- (void)rightBarButtonAction:(UIButton*)button
{
    if (button.tag == 11) {
        //添加图片
        [self addPicAction:button];
    } else if (button.tag == 10) {
        //完成
        [self doneAction:button];
    }
}

- (void)loadTextView
{
    if (!_editTextView) {
        _editTextView = [[MNEditTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _editTextView.textColor = UIColorHex(0x4A4A4A);
        _editTextView.font = kFontPingFangRegularSize(16);
        _editTextView.tintColor = UIColorHex(0x6dffd0);
        _editTextView.textContainerInset = UIEdgeInsetsMake(15, 10, 10, 10);
        _editTextView.delegate = self;
        _editTextView.touchDelegate = self;
        //解决输入图片，文字后，中途插入文字光标自动到最后一行的问题。
        _editTextView.layoutManager.allowsNonContiguousLayout = NO;
        _editTextView.returnKeyType = UIReturnKeyDone;
        [self.view addSubview:_editTextView];
        
        self.selectTextIndex = 0;
        [self notificationRegister];
        
        [_editTextView addTapEvent];
        
//        _editTextView.editable = NO;
//        [self loadDemoDetail];
    }
}

//- (void)tapTextView:(UITapGestureRecognizer*)gesture
//{
//    CGPoint location = [gesture locationInView:_editTextView];
//    CGFloat fraction = 0;
//    NSInteger characterIndex = [_editTextView.layoutManager  characterIndexForPoint:location inTextContainer:_editTextView.textContainer fractionOfDistanceBetweenInsertionPoints:&fraction];
//}

- (void)loadDemoDetail
{
    NSArray *imageNames = @[@"note_image1",@"note_image2",@"note_image2",@"note_image2"];
    
    NSString *text = @"近体诗那份里空间发哦恩菲埃里克非农呢那份林森非非里克非农呢那份林森非非里克非农呢那份林森非非里克非农呢那份林森非非里克非农呢那份林森非非里克非农呢那份林森非非";
    
    _editTextView.text = text;
    
    NSMutableAttributedString *attributedString = [_editTextView.attributedText mutableCopy];
    
    for (int i = 0; i < imageNames.count; i++) {
        UIImage *image = [UIImage imageNamed:imageNames[i]];
        NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = image;
        textAttachment.bounds = CGRectMake(0, 0, _editTextView.frame.size.width-30, [self getImgHeightWithImg:image]);
        NSAttributedString* imageAttachment = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attributedString insertAttributedString:imageAttachment atIndex:10 + i*2];
    }
    
    
    //设置行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, attributedString.length)];
    
    _editTextView.layoutManager.allowsNonContiguousLayout = NO;
    _editTextView.attributedText = attributedString;
}

//取消回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [_editTextView becomeFirstResponder];
    }];
}

#pragma mark UITextViewDelegete
- (void)textViewDidChange:(UITextView *)textView;
{
    NSMutableAttributedString *attributedString = [_editTextView.attributedText mutableCopy];
    //设置字体样式及大小
    [attributedString addAttribute:NSFontAttributeName value:kFontPingFangRegularSize(16) range:NSMakeRange(0, attributedString.length)];
    //设置字体颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorHex(0x4A4A4A) range:NSMakeRange(0, attributedString.length)];
    //设置行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, attributedString.length)];
    
    _editTextView.layoutManager.allowsNonContiguousLayout = NO;
    _editTextView.attributedText = attributedString;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"range = %@ text = %@，textView.text.length = %zd",NSStringFromRange(range),text,textView.text.length);
    if (text.length <= 0) {
        //删除操作
        NSLog(@"文本框删除操作--------");
        //排除只点击了删除键盘，但未删除任何东西也会触发该事件
        if (range.length>0) {
            // 1.如果删除的是图片，找出删除的图片，从数组中移除。更改没有移除的图片在富文本中的索引
            [MSPickerImageModel removeAndUpdateImageObj:range array:self.imageObjs];
        }
    } else {
        //增加操作
        NSLog(@"文本框增加操作++++++++");
        // 二、添加文字时需处理
        range = NSMakeRange(range.location, text.length);
        [MSPickerImageModel updateImageObj:range array:self.imageObjs];
    }

    NSLog(@"self.imageObjs = %@",self.imageObjs);
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    [MSPickerImageModel updateImageObjTouchDeleteRect:self.editTextView.attributedText array:self.imageObjs];
    return YES;
}

- (void)didTapEditTextViewEvent:(MNEditTextView *)view touchPoint:(CGPoint)point
{
    for (int i = 0; i < self.imageObjs.count; i++) {
        MSPickerImageModel *model = [self.imageObjs objectAtIndex:i];
        if (CGRectContainsPoint(model.deleteTouchRect,point)) {
            NSRange range = NSMakeRange(model.imageIndex, 1);
            [MSPickerImageModel removeAndUpdateImageObj:range array:self.imageObjs];
//            [self.imageObjs removeObject:model];
            NSMutableAttributedString *mutAttributeStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.editTextView.attributedText];
            [mutAttributeStr replaceCharactersInRange:range withString:@""];
            self.editTextView.attributedText = mutAttributeStr;
//            self.editTextView.attributedText = [self.editTextView.attributedText replaceCharactersInRange: with:]
            [MSPickerImageModel updateImageObjTouchDeleteRect:self.editTextView.attributedText array:self.imageObjs];
            break;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    NSLog(@"%@,%@,%@",textView,textAttachment,NSStringFromRange(characterRange));
    return YES;
}

//生成文本  包含了图片地址链接  可以直接传给后台制作HTML页面
- (void)doneAction:(id)sender {
    NSString *textStr = [[self textStringWithSymbol:@"[图片]" attributeString:_editTextView.attributedText] mutableCopy];
    int index = 0;
    //通过替换
    for (int i = 0; i <= textStr.length - 4; i ++) {
        NSString *tempStr = [textStr substringWithRange:NSMakeRange(i, 4)];
        if ([tempStr isEqualToString:@"[图片]"]) {
            NSString *imgStr = [NSString stringWithFormat:@"<img src = '%@'/>",self.imgURLArray[index]];
            textStr = [textStr stringByReplacingCharactersInRange:NSMakeRange(i, 4) withString:imgStr];
            index ++;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
//        NSData *data = UIImageJPEGRepresentation(img,0.1);
//        img = [UIImage imageWithData:data];
        [self uploadPicture:img];
        UIImage *showImage = [self resizeImageWithImage:img];
        NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = showImage;
        CGFloat imageHeight = [self getImgHeightWithImg:img];
        CGFloat drawHeight = imageHeight>300?300:imageHeight;
        textAttachment.bounds = CGRectMake(0, 0, _editTextView.frame.size.width-30, drawHeight);
        
        MSPickerImageModel *pickerImageModel = [[MSPickerImageModel alloc] init];
        pickerImageModel.imageIndex = self.selectTextIndex;
        pickerImageModel.image = showImage;
        pickerImageModel.imageHeight = imageHeight;
        [self.imageObjs addObject:pickerImageModel];
        NSLog(@"self.imageObjs = %@",self.imageObjs);
        
        NSAttributedString* imageAttachment = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        NSMutableAttributedString *attributedString = [_editTextView.attributedText mutableCopy];
        [attributedString insertAttributedString:imageAttachment atIndex:self.selectTextIndex];
        
        
        NSMutableAttributedString *nextLine = [[NSMutableAttributedString alloc] init];
        //设置字体样式及大小
        [nextLine addAttribute:NSFontAttributeName value:kFontPingFangRegularSize(16) range:NSMakeRange(0, nextLine.length)];
        //设置字体颜色
        [nextLine addAttribute:NSForegroundColorAttributeName value:UIColorHex(0x4A4A4A) range:NSMakeRange(0, nextLine.length)];
        [attributedString appendAttributedString:nextLine];
        
        //设置行间距
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, attributedString.length)];
        
        _editTextView.layoutManager.allowsNonContiguousLayout = NO;
        _editTextView.attributedText = attributedString;
        
        [MSPickerImageModel updateImageObjTouchDeleteRect:self.editTextView.attributedText array:self.imageObjs];
        [_editTextView becomeFirstResponder];
    }];
}


#pragma mark - 富文本转换操作
/** 将富文本转换为带有图片标志的纯文本*/
- (NSString *)textStringWithSymbol:(NSString *)symbol attributeString:(NSAttributedString *)attributeString{
    NSString *string = attributeString.string;
    string = [self stringDeleteString:@"\n" frontString:@"[图片]" inString:string];
    //最终纯文本
    NSMutableString *textString = [NSMutableString stringWithString:string];
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    //遍历
    [attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length)
                                options:0
                             usingBlock:^(id value, NSRange range, BOOL *stop) {
                                 //检查类型是否是自定义NSTextAttachment类
                                 if (value && [value isKindOfClass:[NSTextAttachment class]]) {
                                     //替换
                                     [textString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:symbol];
                                     //增加偏移量
                                     base += (symbol.length - 1);
                                     //将富文本中最终确认的照片取出来
                                     NSTextAttachment *attachmentImg = (NSTextAttachment *)value;
                                     [self.mutImgArray addObject:attachmentImg.image];
                                 }
                             }];
    //-------------- 最后点击完成事件时 通过对比将富文本中最终确定的照片审选出来 找到对应照片的URl地址
    NSArray *keyArray = [self.mutImgDict allKeys];
    
    for (int i = 0; i < _mutImgArray.count; i ++) {
        UIImage *img = _mutImgArray[i];
        for (int j = 0; j < keyArray.count; j ++) {
            UIImage *myImg = [self.mutImgDict valueForKey:keyArray[j]];
            if (myImg == img) {
                [self.imgURLArray addObject:keyArray[j]];
            }
        }
    }
    //--------------
    return textString;
}

/** 删除字符串*/
- (NSString *)stringDeleteString:(NSString *)deleteString frontString:(NSString *)frontString inString:(NSString *)inString{
    NSArray *ranges = [self rangeOfSymbolString:frontString inString:inString];
    NSMutableString *mutableString = [inString mutableCopy];
    NSUInteger base = 0;
    for (NSString *rangeString in ranges) {
        NSRange range = NSRangeFromString(rangeString);
        [mutableString deleteCharactersInRange:NSMakeRange(range.location - deleteString.length + base, deleteString.length)];
        base -= deleteString.length;
    }
    return [mutableString copy];
}

/** 统计文本中所有图片资源标志的range*/
- (NSArray *)rangeOfSymbolString:(NSString *)symbol inString:(NSString *)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [string stringByAppendingString:symbol];
    NSString *temp;
    for (int i = 0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, symbol.length)];
        if ([temp isEqualToString:symbol]) {
            NSRange range = {i, symbol.length};
            [rangeArray addObject:NSStringFromRange(range)];
        }
    }
    return rangeArray;
}

//上传照片
- (void)uploadPicture:(UIImage *)image
{
    //此处是上传单张图片   ------ 等上传成功后按照下面去存储数据
    /*
     NSDictionary *rawDic = (NSDictionary *)responseObject;
     NSDictionary *infoDic = [rawDic objectForKey:@"info"];
     
     NSString *url = [infoDic valueForKey:@"url"];
     [self.mutImgDict setValue:image forKey:url];
     [self.textView becomeFirstResponder];
     */
}

- (UIImage *)resizeImageWithImage:(UIImage*)image
{
    CGFloat maxWidth = _editTextView.size.width - 30;
    CGFloat imageScaleHeight = [self getImgHeightWithImg:image];
    CGFloat drawHeight = imageScaleHeight>300?300:imageScaleHeight;
    
    CGFloat clipY = 0;
    if (imageScaleHeight>300) {
        clipY = (imageScaleHeight-300)/2;
    }
    
    //生成画布秒板
    UIGraphicsBeginImageContext(CGSizeMake(maxWidth, drawHeight));
    
    //裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, maxWidth, drawHeight) cornerRadius:6];
    [path addClip];
    
    //绘制图片区域
    [image drawInRect:CGRectMake(0, -clipY, maxWidth, imageScaleHeight)];
    
    //贴上删除按钮图片
    UIImage *deleteImage = [UIImage imageNamed:@"icon_remove"];
    [deleteImage drawInRect:CGRectMake(maxWidth - 30, 10, 20, 20)];
    
    //生成最终展示图片
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizeImage;
}

//根据屏幕宽度适配高度
- (CGFloat)getImgHeightWithImg:(UIImage *)img
{
    CGFloat height = ((_editTextView.frame.size.width-20)/ img.size.width) * img.size.height;
    return height;
}

- (void)addPicAction:(id)sender {
    
    if ([_editTextView isFirstResponder]) {
        // 1.2 获取光标位置
        NSRange rg = _editTextView.selectedRange;
        if (rg.location == NSNotFound) {
            // 如果没找到光标,就把光标定位到文字结尾
            rg.location = _editTextView.text.length;
        }
        self.selectTextIndex = rg.location;
    } else {
        self.selectTextIndex = _editTextView.text.length;
    }
    
    UIImagePickerController *imgPicker = [UIImagePickerController new];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

- (void)closeNewNoteView:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButton
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"icon_save_on"] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"icon_save_off"] forState:UIControlStateDisabled];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:kFontPingFangRegularSize(14)];
    doneButton.frame = CGRectMake(0, 0, 60, 36);
    doneButton.tag = 10;
    [doneButton setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    [doneButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItme = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"icon_image"] forState:UIControlStateNormal];
    imageButton.frame = CGRectMake(0, 0, 24, 24);
    imageButton.tag = 11;
    [imageButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *imageItme = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,doneItme,imageItme];
    
}

#pragma mark - Keyboard Methods
- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHidden:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double duration = [number doubleValue];
    [UIView animateWithDuration:duration animations:^{
        _editTextView.frame = CGRectMake(0, 0, kScreenWidth , kScreenHeight - 64);
    }];
}

- (void)keyboardWillShown:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    NSInteger keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double duration = [number doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        _editTextView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - keyboardHeight);
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)mutImgArray
{
    if (!_mutImgArray) {
        _mutImgArray = [NSMutableArray array];
    }
    return _mutImgArray;
}
- (NSMutableDictionary *)mutImgDict
{
    if (!_mutImgDict) {
        _mutImgDict = [NSMutableDictionary dictionary];
    }
    return _mutImgDict;
}
- (NSMutableArray *)imgURLArray
{
    if (!_imgURLArray) {
        _imgURLArray = [NSMutableArray array];
    }
    return _imgURLArray;
}

- (NSMutableArray*)imageObjs
{
    if (!_imageObjs) {
        _imageObjs = [NSMutableArray array];
    }
    return _imageObjs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
