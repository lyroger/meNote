//
//  StatusModel.h
//  HKMember
//
//  Created by 文俊 on 14-3-20.
//  Copyright (c) 2014年 文俊. All rights reserved.
//
#import "BaseModel.h"

@class PageModel;
@interface StatusModel : BaseModel

@property (nonatomic, assign) NSInteger code;           //状态码,0代表成功，其他代表失败
@property (nonatomic, copy) NSString* msg;              //打印信息
@property (nonatomic, strong) id data;                  //数据，对应的Model  eg. xxModel or xxModel数组
@property (nonatomic, strong) id originalData;          //数据，未经过映射的原始数据
@property (nonatomic, strong) PageModel *pageModel;     //分页对象，items数据会解析到data，如想解析分页模型，请在解析类重写+ (BOOL)isPage并返回YES

- (id)initWithCode:(NSInteger)code msg:(NSString *)msg;

- (id)initWithError:(NSError*)error;

// 判断是否是服务器错误，用于判断设置loadingDataFail
- (BOOL)isServersError;

// 手机网络有问题。
- (BOOL)isBadNetWork;

@end



/// 如想解析分页模型，请在解析类重写+ (BOOL)isPage并返回YES
@interface PageModel : BaseModel

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) BOOL hasPrePage;

@property (nonatomic, assign) NSInteger startRow;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, assign) NSInteger prePage;

@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSArray<NSNumber *> *slider;

@end
