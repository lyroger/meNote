#import <Foundation/Foundation.h>

@class HZActivityIndicatorView;

static NSInteger minlengthAccount = 4; // 帐号最少位数
static NSInteger maxlengthAccout = 32; // 帐号最多位数
static NSInteger minlengthPW = 8;      // 密码最少位数
static NSInteger maxlengthPW = 16;     // 密码最多位数

/// 自适应大小类型（宽高，或宽）
typedef enum
{
    /// 自适应宽
    AutoSizeHorizontal,
    /// 自适应宽高
    AutoSizeAll
}AutoSizeType;

@interface DataHelper : NSObject

/// 根据最小尺寸转换图片
+ (UIImage *)scaleImage:(UIImage *)image toMinSize:(float)size;

/// 根据比例转换图片
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

/// 保存图片到Cache
+ (void)saveImage:(UIImage *)tempImage WithPath:(NSString *)path;

/// tableView隐藏多余的线
+ (void)setExtraCellLineHidden:(UITableView *)tableView;

/// 判断gps是否有效
+ (BOOL)gpsIsValidLongitude:(double)longitude latitude:(double)latitude;

/// 获取文件MD5
+ (NSString *)fileMD5:(NSString *)path;

///当需要改变Label中的多段字体属性时调用
+ (NSMutableAttributedString *)getColorsInLabel:(NSString *)allstring ColorString:(NSArray *)colorStringArray Color:(UIColor *)color fontSize:(CGFloat)size;

/// 当需要改变Label中得一段字体属性时调用
+ (NSMutableAttributedString *)getOneColorInLabel:(NSString *)allstring ColorString:(NSString *)string Color:(UIColor*)color fontSize:(float)size;

#pragma mark- 当需要改变Label中得一段字体属性时调用,左边为特殊字体
+ (NSMutableAttributedString *)getColorInLeftString:(NSString *)leftString rightString:(NSString *)rightString  color:(UIColor*)color font:(UIFont*)font;

#pragma mark- 当需要改变Label中得一段字体属性时调用,右边边为特殊字体
+ (NSMutableAttributedString *)getColorInRightString:(NSString *)rightString leftString:(NSString *)leftString color:(UIColor*)color font:(UIFont*)font;

/// 设置textfiled左边的空白
+ (void)setEmptyLeftViewForTextField:(UITextField *)textField withFrame:(CGRect)rect;

///  限制textfild 小数位数为2位
+ (BOOL)setRadixPointForTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/// 金额输入限制位数，可自定义整数位
+ (BOOL)setlimitForTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string number:(int)number;

/// 金额输入限制（首位不能为0）
+ (BOOL)setlimitForTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string number:(int)number shouldBiggerThanOne:(BOOL)bigger;

/// 密码输入长度限制
+ (BOOL)setlimitPwdForTextField:(UITextField *)textField number:(int)number min:(BOOL)min;

/// string to number
+ (NSNumber *)stringToNum:(NSString *)string;

/// 加密手机号
+ (NSString *)getSecretStylePhone:(NSString *)phoneStr;

/// 替换frame 的高度
+ (CGRect)changeFrame:(CGRect)frame setHeight:(CGFloat)height;

/// 设置view的边框属性
+ (void)setlayerWithView:(UIView *)view radius:(CGFloat)radius borderColor:(UIColor *)bordercolor borderWidth:(CGFloat)borderwidth;

/// 清除本地缓存文件
+ (void)clearCacheFile;

/// 计算本地缓存文件大小
+ (double)getCacheFileSize;

/// 图片拉升
+ (UIImage *)resizableImage:(UIImage *)image;

/// 计算时间差（date计算后返回秒）
+ (int)getTimeInterval:(NSDate *)currentDate sinceDate:(NSDate *)sinceDate;

/// 是否是手机号码的字符串
+ (BOOL)isNumberString:(NSString *)string;

/// 网络请求是否异常（如404，500等）
+ (BOOL)webRequestStatus:(NSString *)infoStr;

/**
 *  获取文件各项属性方法
 *
 *  @param fileName 文件流
 */
+ (NSData *)applicationDataFromFile:(NSString *)fileName;

/// 逗号分隔表示金额的字符串
+ (NSString *)spliteMoneyString:(NSString *)moneyStr;

/// 截取小数点后几位方法 moneyStr：金额字符串 nuberCount：保留小数点后几位不做四舍五入
/// 如剧情需要可设置基数加100即可 例：102表示保留2位小数 当值为0.00时自动转换为0
+ (NSString *)interceptMoneyString:(NSString *)moneyStr numberCount:(NSInteger)nuberCount;

///获取星星
+ (NSString *)getStarStr:(NSUInteger)starNum;

/// 数组中相同的元素只保留一个
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array;

@end
