//
//  SHMUserInfo.m
//  SellHouseManager
//
//  Created by luoyan on 16/5/24.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "MNUserInfo.h"
#import "HttpClient.h"
#import "SSKeychain.h"
#import "NSDictionary+BaseModel.h"

@implementation MNUserInfo

+ (LKDBHelper *)getUsingLKDBHelper {
    return [super getDefaultLKDBHelper];
}

+ (NSString*)getTableName
{
    return @"MNUserInfoV1";
}

+ (NSString*)getPrimaryKey
{
    return @"userId";
}

+ (instancetype)shareUserInfo
{
    static MNUserInfo *userInfo = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        userInfo = [[MNUserInfo alloc] init];
    });
    return userInfo;
}

- (void)setUserInfo:(MNUserInfo*)userInfo
{
    _userId = userInfo.userId;
    _userName = userInfo.userName;
    _caseId = userInfo.caseId;
    _caseName = userInfo.caseName;
    _token = userInfo.token;
    _phone = userInfo.phone;
    _headerImg = userInfo.headerImg;
    _declaration = userInfo.declaration;
    _cityId = userInfo.cityId;
    _cityName = userInfo.cityName;
    _lastCityId = userInfo.lastCityId;
    _lastCityName = userInfo.lastCityName;
    
    _isRememberPwd = userInfo.isRememberPwd;
    _userAcount = userInfo.userAcount;
    _isRegisterPushInfo = userInfo.isRegisterPushInfo;
}

- (void)getUserInfoFromLocal
{
    NSString *userAcount = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUserAcount];
    if (userAcount.length) {
        MNUserInfo *userInfo = [MNUserInfo searchSingleWithWhere:[NSString stringWithFormat:@"userAcount='%@'",userAcount] orderBy:nil];
        [self setUserInfo:userInfo];
    }
}

- (BOOL)savePassword:(NSString*)password
{
    return [SSKeychain setPassword:password forService:@"com.exmind.sellhousemanager" account:self.userAcount];
}

- (BOOL)deletePassword
{
    return [SSKeychain deletePasswordForService:@"com.exmind.sellhousemanager" account:self.userAcount];
}

- (NSString*)getPassword
{
    return [SSKeychain passwordForService:@"com.exmind.sellhousemanager" account:self.userAcount];
}
#pragma mark DeviceToken
// 保存设备token；
- (BOOL)saveDeviceToken:(NSData*)deviceToken
{
    BOOL removed = [SSKeychain deletePasswordForService:[self getDeviceTokenService] account:@"sellhousemanagerDeviceToken"];
    NSLog(@"removeDeviceToken = %d",removed);
    BOOL worked = [SSKeychain setPasswordData:deviceToken forService:[self getDeviceTokenService] account:@"sellhousemanagerDeviceToken"];
    NSLog(@"addDeviceToken = %d",worked);
    return worked;
}
// 获取设备token；
- (NSData*)getDeviceToken
{
    return [SSKeychain passwordDataForService:[self getDeviceTokenService] account:@"sellhousemanagerDeviceToken"];
}

- (NSString*)getDeviceTokenService
{
    return [NSString stringWithFormat:@"com.exmind.sellhousemanager_Token%d",isTrueEnvironment];
}

+ (NSURLSessionDataTask *)loginWithLoginId:(NSString *)loginId
                                  password:(NSString *)password
                                networkHUD:(NetworkHUD)hud
                                    target:(id)target
                                   success:(NetResponseBlock)success {
    CreateParamsDic;
    DicObjectSet(loginId, @"loginId");
    DicObjectSet(password, @"password");
    DicObjectSet(@"sellhouse", @"componentName");
    return [self dataTaskMethod:HTTPMethodPOST path:@"v1/sessions/appLogin" params:ParamsDic networkHUD:hud target:target success:success];
}

+ (NSURLSessionDataTask *)loginOutNetworkHUD:(NetworkHUD)hud
                                      target:(id)target
                                     success:(NetResponseBlock)success
{
    return [self dataTaskMethod:HTTPMethodDELETE path:[NSString stringWithFormat:@"v1/sessions/logout/%@",[MNUserInfo shareUserInfo].token] params:nil networkHUD:hud target:target success:success];
}

+ (NSURLSessionDataTask *)feedbacks:(NSString*)content
                         networkHUD:(NetworkHUD)hud
                             target:(id)target
                            success:(NetResponseBlock)success
{
    
    CreateParamsDic;
    DicObjectSet(content, @"content");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/v1/app/feedbacks" params:ParamsDic networkHUD:hud target:target success:success];
}

+ (NSURLSessionDataTask *)uploadHeadPhoto:(UIImage *)headPhoto
                                      hud:(NetworkHUD)hud
                                   target:(id)target
                                  success:(NetResponseBlock)success
{
    CreateParamsDic;
    NSMutableArray *array = [NSMutableArray array];
    UIImage *image = headPhoto;
    NSData *data = UIImageJPEGRepresentation(image,0.5);
    NSDictionary *fileDic = [NSDictionary bm_dictionaryWithData:data
                                                       name:@"imageFiles"
                                                   fileName:[NSString stringWithFormat:@"file0.jpg"]
                                                   mimeType:@"image/jpg"];
    [array addObject:fileDic];
    
    return [self updataFile:@"api/v1/sysUsers/uploadHeadImg" files:array params:ParamsDic networkHUD:hud target:target success:success];
}

@end
