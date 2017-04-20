//
//  BaseModel.m
//
//  QQ:275080225
//  Created by wen jun on 12-10-13.
//  Copyright (c) 2013年 Wen Jun. All rights reserved.
//

#import "BaseModel.h"
#import "StatusModel.h"

#import "HttpClient.h"
#import "NetCache.h"

#import "BaseModel+HUD.h"
#import "NSDictionary+BaseModel.h"
#import "NSString+BaseModel.h"
#import "AFHTTPSessionManager_BaseModel.h"

typedef enum : NSUInteger {
	AuthStatusSucceed,
	AuthStatusAccessFail,
	AuthStatusUserFail,
} AuthStatus;

@implementation BaseModel

+ (void)initialize {
    if (self == [BaseModel self]) {
//        [HttpClient startWithURL:kServerHost];
        
        [HttpClient sharedInstance].responseType = ResponseJSON;
        [HttpClient sharedInstance].requestType = RequestJSON;
    }
}

#pragma mark - DB
static LKDBHelper* userHelper;
static dispatch_once_t userOnceToken;

+ (LKDBHelper *)getUserLKDBHelper {
	NSString *dbName = [NSString stringWithFormat:@"MN%@",[MNUserInfo shareUserInfo].userId];
	dispatch_once(&userOnceToken, ^{
        userHelper = [[LKDBHelper alloc] initWithDBName:dbName];
        [userHelper setKey:[[dbName stringByAppendingString:@"qkjskl"] md5String]];
        

	});
	[userHelper setDBName:dbName];
	return userHelper;
}

+ (void)releaseLKDBHelp {
	userOnceToken = 0;
	userHelper = nil;
}

+ (LKDBHelper *)getUsingLKDBHelper {
	LKDBHelper *helper;
	if ([MNUserInfo shareUserInfo].userId) {
		helper = [self getUserLKDBHelper];
	} else {
		helper = [self getDefaultLKDBHelper];
	}
	return helper;
}

+ (LKDBHelper *)getDefaultLKDBHelper {
	static LKDBHelper* helper;
	static dispatch_once_t onceToken;
	NSString *dbName = @"SHMDefault";
	dispatch_once(&onceToken, ^{
        helper = [[LKDBHelper alloc]initWithDBName:dbName];
        [helper setKey:[[dbName stringByAppendingString:@"qkjskl"] md5String]];
	});
	[helper setDBName:[NSString stringWithFormat:@"%@.db",dbName]];
	return helper;
}

#pragma mark - map
+ (StatusModel *)statusModelFromJSONObject:(id)object {
	return [self statusModelFromJSONObject:object class:self];
}

+ (StatusModel *)statusModelFromJSONObject:(id)object class:(Class) class {
	StatusModel *statusModel = [StatusModel mj_objectWithKeyValues:object[@"status"]];
	id returnObject = nil;
	id rs = object[@"data"];
	if (rs) {
		if ([rs isKindOfClass:[NSDictionary class]]) {
            
            BOOL isPage = [class isPage];
            if (isPage) {
                statusModel.pageModel = [PageModel mj_objectWithKeyValues:rs];
                returnObject = [class mj_objectArrayWithKeyValuesArray:rs[@"items"]];
            }else{
                returnObject = [class mj_objectWithKeyValues:rs];
            }
            
		} else if ([rs isKindOfClass:[NSArray class]]) {
			returnObject = [class mj_objectArrayWithKeyValuesArray:rs];
        } else if ([rs isKindOfClass:[NSNull class]]) {
            returnObject = nil;
        }
    }
    statusModel.data = returnObject;
	statusModel.originalData = rs;
	return statusModel;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             @"desc" : @"description"
             };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class]) {
        if ([oldValue isKindOfClass:[NSNumber class]]) {
            return [NSDate dateWithTimeIntervalSince1970:[oldValue doubleValue]/1000];
        }
        
        if ([oldValue isKindOfClass:[NSString class]]) {
            NSString *dateFormatter = nil;
            switch (((NSString *)oldValue).length) {
                case 10:
                    dateFormatter = @"yyyy-MM-dd";
                    break;
                case 16:
                    dateFormatter = @"yyyy-MM-dd HH:mm";
                    break;
                case 21:
                    dateFormatter = @"yyyy-MM-dd HH:mm:ss.S";
                    break;
                default:
                    dateFormatter = @"yyyy-MM-dd HH:mm:ss";
                    break;
            }
            return [NSDate dateWithString:oldValue format:dateFormatter];
        }
    }
    
    return oldValue;
}

#pragma mark - network related methods
+ (NSURLSessionDataTask *)dataTaskMethod:(HTTPMethod)method
                                    path:(NSString *)path
                                  params:(id)params
                              networkHUD:(NetworkHUD)networkHUD
                                  target:(id)target
                               cacheTime:(NSInteger)cacheTime
                               dbSuccess:(DBResultBlock)dbResult
                                 success:(NetResponseBlock)success {
    return [[self class] dataTaskMethod:method
                                   path:path
                                 params:params
                             networkHUD:networkHUD
                                 target:target
                         uploadProgress:nil
                       downloadProgress:nil
                              cacheTime:cacheTime
                              dbSuccess:dbResult
                                success:success];
}

+ (NSURLSessionDataTask *)dataTaskMethod:(HTTPMethod)method
                                    path:(NSString *)path
                                  params:(id)params
                              networkHUD:(NetworkHUD)networkHUD
                                  target:(id)target
                                 success:(NetResponseBlock)success {
    
    return [self dataTaskMethod:method
                           path:path
                         params:params
                     networkHUD:networkHUD
                         target:target
                      cacheTime:0
                      dbSuccess:nil
                        success:success];
}

+ (NSURLSessionDataTask *)dataTaskMethod:(HTTPMethod)method
                                    path:(NSString *)path
                                  params:(id)params
                              networkHUD:(NetworkHUD)networkHUD
                                 success:(NetResponseBlock)success {
    
    return [self dataTaskMethod:(HTTPMethod)method
                           path:path
                         params:params
                     networkHUD:networkHUD
                         target:nil
                      cacheTime:0
                      dbSuccess:nil
                        success:success];
}

#pragma mark - Private Network request
//time==-1.同时取数据库/网络 time==0.不取数据库直接取网络  time>1  根据超时取数据库还是取网络
+ (NSURLSessionDataTask *)dataTaskMethod:(HTTPMethod)method
                                    path:(NSString *)path
                                  params:(id)params
                              networkHUD:(NetworkHUD)networkHUD
                                  target:(id)target
                          uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                        downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               cacheTime:(NSInteger)cacheTime
                               dbSuccess:(DBResultBlock)dbResult
                                 success:(NetResponseBlock)success {
    
    if (![path hasPrefix:@"http"]) {
        if ([path hasPrefix:@"/"]) {
            path = [path substringFromIndex:1];
        }
        path = [NSString stringWithFormat:@"%@%@%@",kServerHost,kServerCurrentPath,path];
    }
    
    params = [self parametersHandler:params path:path];
    __block NSURLSessionDataTask *dataTask;
    if (dbResult && (cacheTime == -1 || cacheTime>0)) {
        [NetCache queryWithPath:path parameter:[self removeDBUselessKey:params] result:^(NetCache *data) {
            BOOL getNet = YES;
            NetCache *cache = data;
            if (cache) {
                NSDate *date = [NSDate dateWithTimeInterval:-cacheTime sinceDate:[NSDate date]];
                if (cacheTime == -1 || (cache.updateDate && [cache.updateDate compare:date] == NSOrderedDescending)) {
                    id JSON = [cache.content bm_dictionaryWithJSON];
                    dbResult ([self statusModelFromJSONObject:JSON]);
                    getNet = NO;
                }
            }
            if (cacheTime == -1) {
                getNet = NO;
            }
            //根据需要是否调网络（未完待续）
            if (getNet) {
                dataTask = [self netDataTaskMethod:method
                                              path:path
                                            params:params
                                        networkHUD:networkHUD
                                            target:target
                                    uploadProgress:uploadProgress
                                  downloadProgress:downloadProgress
                                         dbSuccess:dbResult
                                           success:success];
            }
        }];
    }
    if(cacheTime == -1 || cacheTime == 0 || !dbResult){
        dataTask = [self netDataTaskMethod:method
                                      path:path
                                    params:params
                                networkHUD:networkHUD
                                    target:target
                            uploadProgress:uploadProgress
                          downloadProgress:downloadProgress
                                 dbSuccess:dbResult
                                   success:success];
    }
    return dataTask;
}

//内部方法禁止调用
+ (NSURLSessionDataTask *)netDataTaskMethod:(HTTPMethod)method
                                       path:(NSString *)path
                                     params:(id)params
                                 networkHUD:(NetworkHUD)networkHUD
                                     target:(id)target
                             uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                           downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                  dbSuccess:(DBResultBlock)dbResult
                                    success:(NetResponseBlock)success {
    
    [self startHUD:networkHUD target:target];
    NSString *methodStr;
    switch (method) {
        case HTTPMethodGET:
            methodStr = @"GET";
            break;
        case HTTPMethodPOST:
            methodStr = @"POST";
            break;
        case HTTPMethodPUT:
            methodStr = @"PUT";
            break;
        case HTTPMethodDELETE:
            methodStr = @"DELETE";
            break;
        case HTTPMethodHEAD:
            methodStr = @"HEAD";
            break;
        case HTTPMethodPATCH:
            methodStr = @"PATCH";
            break;
    }
    
#ifndef __OPTIMIZE__
    NSString *jsonString = @"";
    if (params) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
    NSLog (@"%@:%@\n%@\n%@\n", methodStr, path, jsonString ,kHttpClient.requestSerializer.HTTPRequestHeaders);
#endif

    NSURLSessionDataTask *dataTask = [kHttpClient dataTaskWithHTTPMethod:methodStr
                                                               URLString:path
                                                              parameters:params
                                                          uploadProgress:uploadProgress
                                                        downloadProgress:downloadProgress
                                                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                     id JSON = [self getObjectFromReponseObject:responseObject];
                                                                     StatusModel *model;
                                                                     if (JSON) {
                                                                         model = [[self class] statusModelFromJSONObject:JSON];
                                                                     } else {
                                                                         model = [[StatusModel alloc] initWithCode:-100
                                                                                                               msg:NSLocalizedString (@"json_error", nil)];
                                                                     }
                                                                     [self checkResponseCode:model];
                                                                     
                                                                     if ([self isCacheStatusModel:model] && dbResult) {
                                                                         [NetCache cacheWithPath:path
                                                                                       parameter:[self removeDBUselessKey:params]
                                                                                         content:JSON];
                                                                     }
                                                                     
                                                                     [self handleResponse:model networkHUD:networkHUD];
                                                                     if(success) {
                                                                         success (model);
                                                                     }
                                                                 }failure:^(NSURLSessionDataTask *task, NSError *error)
                                      {
#ifndef __OPTIMIZE__
//                                          DLog (@"\n响应：--------------------->%@%@\n%@", kServerHost, path, error.localizedDescription);
#endif
                                          NSLog(@"%@",error.localizedDescription);
                                          StatusModel *model = [[StatusModel alloc] initWithError:error];
                                          [self handleResponse:model networkHUD:networkHUD];
                                          if(success) {
                                              success(model);
                                          }
                                      }
                                      ];
    
    [dataTask resume];
    
    if (target && [target respondsToSelector:@selector (addNet:)]) {
        [target performSelector:@selector (addNet:) withObject:dataTask];
    }
    return dataTask;
}

+ (NSURLSessionDataTask *)updataFile:(NSString *)path
                               files:(NSArray *)files
                              params:(id)params
                          networkHUD:(NetworkHUD)networkHUD
                              target:(id)target
                             success:(NetResponseBlock)success{
    
    if (![path hasPrefix:@"http"]) {
        path = [NSString stringWithFormat:@"%@%@%@",kServerHost,kServerCurrentPath,path];
    }
    [self startHUD:networkHUD target:target];
//    kHttpClient.requestType = RequestOther;
//    kHttpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"multipart/form-data"];
//    kHttpClient.requestSerializer.acceptableContentTypes = [NSSet setWithObject:@"multipart/form-data"];
    
    params = [self parametersHandler:params path:path];
    
#ifndef __OPTIMIZE__
    NSString *jsonString = @"";
    if (params) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
    NSLog (@"\n上传文件：%@%@\n%@\n%@\n", kServerHost, path, jsonString,kHttpClient.requestSerializer.HTTPRequestHeaders);
#endif
    
    void (^bodyBlock)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *uploadInfo = obj;
            [formData appendPartWithFileData:uploadInfo.data
                                        name:uploadInfo.name
                                    fileName:uploadInfo.fileName
                                    mimeType:uploadInfo.mimeType];
        }];
    };
    
    NSURLSessionUploadTask *uploadTask = (NSURLSessionUploadTask *)[kHttpClient POST:path
                                                                          parameters:params
                                                           constructingBodyWithBlock:bodyBlock
                                                                            progress:^(NSProgress * _Nonnull uploadProgress) {
                                                                                
                                                                            }success:^(NSURLSessionDataTask *task, id responseObject)
    {
        id JSON = [self getObjectFromReponseObject:responseObject];
        StatusModel *model;
        if (JSON) {
            model = [[self class] statusModelFromJSONObject:JSON];
        } else {
            model = [[StatusModel alloc] initWithCode:-100 msg:NSLocalizedString (@"json_error", nil)];
        }
        [self checkResponseCode:model];
        [self handleResponse:model networkHUD:networkHUD];
        if(success) {
            success (model);
        }
    }
                                                                             failure:^(NSURLSessionDataTask *task, NSError *error)
    {
                                                                                
#ifndef __OPTIMIZE__
        DLog (@"\n响应：--------------------->%@%@\n%@", kServerHost, path, error.localizedDescription);
#endif
        StatusModel *model = [[StatusModel alloc] initWithError:error];
        [self handleResponse:model networkHUD:networkHUD];
        if(success) {
            success(model);
        }
    }];
    return uploadTask;
}

#pragma mark - Inner Method
+ (id)getObjectFromReponseObject:(id)responseObject {
	NSDictionary *value = nil;
	if ([responseObject isKindOfClass:[NSDictionary class]] &&
		kHttpClient.responseType == ResponseJSON) {
		value = responseObject;
#ifndef __OPTIMIZE__
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DLog (@"\n响应：--------------------->%@",jsonString);
#endif
	} else {
		NSString *responseString = nil;
		if ([responseObject isKindOfClass:[NSData class]]) {
			responseString =
				[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		} else {
			responseString = responseObject;
		}
		/**
		 *  处理服务器返回数据
		 */
		responseString = [self responseStringHandler:responseString];

		NSError *decodeError = nil;

		NSData *decodeData = [responseString dataUsingEncoding:NSUTF8StringEncoding];

		if (kHttpClient.responseType == ResponseJSON) {
			value = [NSJSONSerialization JSONObjectWithData:decodeData
													options:NSJSONReadingAllowFragments
													  error:&decodeError];
		}
	}
	return value ?: @{};
}

+ (void)checkResponseCode:(StatusModel *)model
{
    if (model.code == 401) {
        //token失效，需重新登录
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUserTokenExpireNotification object:nil];
    }
}

+ (NSDictionary *)parametersHandler:(NSDictionary *)params path:(NSString *)path {
//    NSString *token = [SHMUserInfo shareUserInfo].token;
//    if (token.nonNull) {
//        [kHttpClient.requestSerializer setValue:token forHTTPHeaderField:@"X-Token"];
//    }
//    NSString *caseId = [SHMUserInfo shareUserInfo].caseId;
//    if (caseId.nonNull) {
//        NSString *cookie = [NSString stringWithFormat:@"caseId=%@",caseId];
//        [kHttpClient.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
//    }
//    if (caseId.nonNull) {
//        [kHttpClient.requestSerializer setValue:caseId forHTTPHeaderField:@"X-CaseId"];
//    }
    
    //添加版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [kHttpClient.requestSerializer setValue:currentVersion forHTTPHeaderField:@"X-version"];
    
    //添加设备类型
    [kHttpClient.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-appOS"];
    
	return [self encryptForSomeFields:params];
}

+ (NSString *)responseStringHandler:(NSString *)responseString {
	return responseString;
}

/// 加密处理
+ (NSDictionary *)encryptForSomeFields:(NSDictionary *)path {
	return path;
}

/// 删除DB缓存params不需要的字段
+ (NSDictionary *)removeDBUselessKey:(NSDictionary *)params {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
//    [dic setValue:[SHMUserInfo shareUserInfo].caseId forKey:@"db_CaseId"];
//    if ([SHMUserInfo shareUserInfo].userId) {
//        [dic setValue:[SHMUserInfo shareUserInfo].userId forKey:@"db_UserId"];
//    }
	return dic;
}

/// 是否缓存，子类可以根据 flag返回对应值
+ (BOOL)isCacheStatusModel:(StatusModel*)model
{
    if (model.code == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPage
{
    return NO;
}

@end
