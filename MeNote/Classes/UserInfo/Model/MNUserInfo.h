//
//  SHMUserInfo.h
//  SellHouseManager
//
//  Created by luoyan on 16/5/24.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "BaseModel.h"

@interface MNUserInfo : BaseModel

@property (nonatomic, copy) NSString *userId;           //用户ID
@property (nonatomic, copy) NSString *userName;         //用户姓名
@property (nonatomic, copy) NSString *caseId;           //案场ID
@property (nonatomic, copy) NSString *caseName;         //案场名称
@property (nonatomic, copy) NSString *phone;            //手机号码
@property (nonatomic, copy) NSString *token;            //用户token
@property (nonatomic, copy) NSString *headerImg;        //用户头像
@property (nonatomic, copy) NSString *declaration;      //用户宣言
@property (nonatomic, copy) NSString *cityName;         //当前案场所在城市名称
@property (nonatomic, assign) NSInteger cityId;         //当前案场所在城市id
@property (nonatomic, copy) NSString *lastCityName;     //上次在app中选择的城市名称
@property (nonatomic, assign) NSInteger lastCityId;     //上次在app中选择的城市ID

//附加功能属性
@property (nonatomic, copy) NSString *userAcount;   //账号
@property (nonatomic, assign) BOOL isRememberPwd;
@property (nonatomic, assign) BOOL isRegisterPushInfo; //该用户是否注册推送通知信息成功

+ (instancetype)shareUserInfo;

- (void)setUserInfo:(MNUserInfo*)userInfo;
//启动app时，从本地数据库加载数据到单例中
- (void)getUserInfoFromLocal;
//保存密码
- (BOOL)savePassword:(NSString*)password;
//删除密码
- (BOOL)deletePassword;
//获取当前账号密码
- (NSString*)getPassword;
// 保存设备token；
- (BOOL)saveDeviceToken:(NSData*)deviceToken;
// 获取设备token；
- (NSData*)getDeviceToken;

+ (NSURLSessionDataTask *)loginWithLoginId:(NSString *)loginId
                                  password:(NSString *)password
                                networkHUD:(NetworkHUD)hud
                                    target:(id)target
                                   success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)loginOutNetworkHUD:(NetworkHUD)hud
                                      target:(id)target
                                     success:(NetResponseBlock)success;

//用户反馈意见
+ (NSURLSessionDataTask *)feedbacks:(NSString*)content
                         networkHUD:(NetworkHUD)hud
                             target:(id)target
                            success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)uploadHeadPhoto:(UIImage *)headPhoto
                                      hud:(NetworkHUD)hud
                                      target:(id)target
                                     success:(NetResponseBlock)success;
@end
