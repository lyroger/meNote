//
//  MicLocationAssistant.m
//  HKMember
//
//  Created by apple on 14-4-14.
//  Copyright (c) 2014年 惠卡. All rights reserved.
//

#import "MicAssistant.h"
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation MicAssistant

+ (id)sharedInstance
{
    static MicAssistant *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)isLocationServiceOn
{
    return [CLLocationManager locationServicesEnabled];
}

- (BOOL)isCurrentAppLocatonServiceOn
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isLocationServiceDetermined
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusNotDetermined == status) {
        return NO;
    } else {
        return YES;
    }
    
}

- (BOOL)isCurrentAppALAssetsLibraryServiceOn
{
    BOOL isServiceOn;
    if (ISIOS8) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        // 此处只应判断拒绝的情况，第一次未决定时返回YES，不做任何弹框，系统自己弹
        if (status == PHAuthorizationStatusDenied) {
            isServiceOn = NO;
        } else {
            isServiceOn = YES;
        }
    } else {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        // 此处只应判断拒绝的情况，第一次未决定时返回YES，不做任何弹框，系统自己弹
        if (status == kCLAuthorizationStatusDenied) {
            isServiceOn = NO;
        } else {
            isServiceOn = YES;
        }
    }
    return isServiceOn;
}

- (BOOL)isCameraServiceOn
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isMailServiceOn
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    __block BOOL isCan = NO;
    
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 if (error) {
                     NSLog(@"Error: %@", (__bridge NSError *)error);
                 } else if (!granted) {
                     isCan = NO;
                 } else {
                     isCan = YES;
                 }
            });
        });
    } else {
        isCan = NO;
        CFRelease(addressBook);
    }
    
    return isCan;
}

- (void)checkCameraServiceOnCompletion:(void (^)(BOOL isPermision, BOOL isFirstAsked))completion
{
    __block BOOL permision = NO;
    __block BOOL firstAsked = NO;
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        /* 询问用户是否允许 */
        firstAsked = YES;
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            firstAsked = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                permision = granted;
                if (completion) { completion(permision, firstAsked); }
            });
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted){
        /* 无权限 */
        permision = NO;
        firstAsked = NO;
        if (completion) { completion(permision, firstAsked); }
    } else {
        /* 有权限 */
        permision = YES;
        firstAsked = NO;
        if (completion) { completion(permision, firstAsked); }
    }
}

- (void)checkPhotoServiceOnCompletion:(void (^)(BOOL isPermision, BOOL isFirstAsked))completion
{
    __block BOOL permision = NO;
    __block BOOL firstAsked = NO;
    if (ISIOS8) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            /* 询问用户授权 */
            firstAsked = YES;
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    permision = status == PHAuthorizationStatusAuthorized ? YES : NO;
                    if (completion) { completion(permision, firstAsked); }
                });
            }];
        } else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            /* 无权限 */
            permision = NO;
            firstAsked = NO;
            if (completion) { completion(permision, firstAsked); }
        } else {
            /* 有权限 */
            permision = YES;
            firstAsked = NO;
            if (completion) { completion(permision, firstAsked); }
        }
    } else {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
            /* 无权限 */
            permision = NO;
            firstAsked = NO;
            if (completion) { completion(permision, firstAsked); }
        } else if (status == ALAuthorizationStatusNotDetermined) {
            /* 还未确定 */
            //do nothing
        } else {
            /* 有权限 */
            permision = YES;
            firstAsked = NO;
            if (completion) { completion(permision, firstAsked); }
        }
    }
}

- (void)checkMicrophoneServiceOnCompletion:(void (^)(BOOL isPermision, BOOL isFirstAsked))completion
{
    __block BOOL permision = NO;
    __block BOOL firstAsked = NO;
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(recordPermission)]) {
        // ios8以上版本
        /* 当前的权限状态 */
        AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
        if (permission == AVAudioSessionRecordPermissionUndetermined) {
            firstAsked = YES;
            /* 如果还没有确定权限，则需要询问用户是否允许 */
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    permision = granted;
                    if (completion) { completion(permision, firstAsked); }
                });
            }];
        } else if (permission == AVAudioSessionRecordPermissionGranted) {
            /* 用户允许 */
            firstAsked = NO;
            permision = YES;
            if (completion) { completion(permision, firstAsked); }
        } else {
            /* 用户不允许 */
            firstAsked = NO;
            permision = NO;
            if (completion) { completion(permision, firstAsked); }
        }
    } else if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        // ios7 是利用 requestRecordPermission,回调只能判断允许或者未被允许
        NSDate *date = [NSDate date];
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // ios7无法判断是否是出于未决定的状态,但是一旦判断，很快回调，所以可以用一个比较短的时间差来达到比较精准的判断
                NSDate *date2 = [NSDate date];
                NSTimeInterval timeGap = [date2 timeIntervalSinceDate:date];
                if (timeGap > 0.5) {
                    firstAsked = YES;
                } else {
                    firstAsked = NO;
                }
                permision = granted;
                
                if (completion) { completion(permision, firstAsked); }
            });
        }];
        
    } else {
        // 7以前不用检测权限
        permision = YES;
        firstAsked = NO;
        if (completion) { completion(permision, firstAsked); }
    }
}

+ (void)guidUserToSettingsWhenNoAccessRight:(NoAccessType)type
{
    NSArray *titleArray = @[@"没有相册访问权限", @"没有相机访问权限", @"没有打开定位服务", @"没有通讯录访问权限", @"没有麦克风访问权限"];
    NSArray *messageNot = @[@"请在iPhone的“设置-隐私-照片”\n允许访问您的手机照片",
                            @"请在iPhone的“设置-隐私-相机”\n允许访问您的手机相机",
                            @"请在iPhone的“设置-隐私-定位服务”\n允许使用您的手机定位服务",
                            @"请在iPhone的“设置-隐私-通讯录”\n允许访问您的手机通讯录",
                            @"请在iPhone的“设置-隐私-麦克风”\n允许访问您的手机麦克风"];
    NSArray *messageCan = @[@"立即前往iPhone的“卖房管家-照片”\n允许访问您的手机照片",
                            @"立即前往iPhone的“卖房管家-相机”\n允许访问您的手机相机",
                            @"立即前往iPhone的“卖房管家-定位服务”\n允许使用您的手机定位服务",
                            @"立即前往iPhone的“卖房管家-通讯录”\n允许访问您的手机通讯录",
                            @"立即前往iPhone的“卖房管家-麦克风”\n允许访问您的手机麦克风"];
    
    NSString *title, *message, *otherStr;
    if (ISIOS8) {
        message = messageCan[type];
        otherStr = @"去设置";
    } else {
        otherStr = @"确定";
        message = messageNot[type];
    }
    title = titleArray[type];

    [UIAlertView bk_showAlertViewWithTitle:title message:message cancelButtonTitle:@"取消" otherButtonTitles:@[otherStr] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (ISIOS8 && buttonIndex == 1) {
            dispatch_after(0.01, dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            });
        }
    }];
}

- (BOOL)checkAccessPermissions:(NoAccessType)type
{
    NSURL *url;
    BOOL isCanOpen = NO;
    if (ISIOS8) {
        url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        isCanOpen = [[UIApplication sharedApplication] canOpenURL:url];
    }
    __block BOOL isCan = NO;
    if (type == NoAccessPhotoType) {
        // 相相册权限判断
        // 此处只应判断拒绝的情况，未决定时，不做任何弹框，系统自己弹
        if (ISIOS8) {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusDenied) {
                isCan = NO;
                isCanOpen = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            } else if (status == PHAuthorizationStatusNotDetermined){
                return YES;
            } else {
                isCan = YES;
            }
        } else {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            if (status == kCLAuthorizationStatusDenied) {
                isCan = NO;
            } else if (status == kCLAuthorizationStatusNotDetermined){
                return YES;
            } else {
                isCan = YES;
            }
        }
    } else if (type == NoAccessCamaratype) {
        // 相机权限判断
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusDenied) {
            isCan = NO;
        } else if (status == AVAuthorizationStatusNotDetermined){
            return YES;
        } else {
            isCan = YES;
        }
    } else if (type == NoAccessLocationType) {
        // 定位服务判断
        // 先判断用户是否决定，再手机定位是否开启，最后判断是否允许APP使用定位
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == AVAuthorizationStatusNotDetermined) {
            return YES;
        } else {
            // 是否打开定位
            BOOL isServerOn = [CLLocationManager locationServicesEnabled];
            if (isServerOn) {
                if (status == AVAuthorizationStatusDenied) {
                    isCan = NO;
                } else {
                    isCan = YES;
                }
            } else {
                isCan = NO;
                url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
                isCanOpen = [[UIApplication sharedApplication] canOpenURL:url];
            }
        }
    } else if (type == NoAccessMailType) {
        isCan = [self isMailServiceOn];
    } else if (type == NoAccessMicrophoneType) {
        [self checkMicrophoneServiceOnCompletion:^(BOOL isPermision, BOOL isFirstAsked) {
            if (isFirstAsked) {
                isCan = isFirstAsked;
            } else {
                isCan = isPermision;
            }
        }];
    }
    //权限未打开
    if (!isCan) {
        NSArray *titleArray = @[@"没有相册访问权限", @"没有相机访问权限", @"没有打开定位服务", @"没有通讯录访问权限", @"没有麦克风访问权限"];
        NSArray *messageNot = @[@"请在iPhone的“设置-隐私-照片”\n允许访问您的手机照片",
                                @"请在iPhone的“设置-隐私-相机”\n允许访问您的手机相机",
                                @"请在iPhone的“设置-隐私-定位服务”\n允许使用您的手机定位服务",
                                @"请在iPhone的“设置-隐私-通讯录”\n允许访问您的手机通讯录",
                                @"请在iPhone的“设置-隐私-麦克风”\n允许访问您的手机麦克风"];
        NSArray *messageCan = @[@"立即前往iPhone的“卖房管家-照片”\n允许访问您的手机照片",
                                @"立即前往iPhone的“卖房管家-相机”\n允许访问您的手机相机",
                                @"立即前往iPhone的“卖房管家-定位服务”\n允许使用您的手机定位服务",
                                @"立即前往iPhone的“卖房管家-通讯录”\n允许访问您的手机通讯录",
                                @"立即前往iPhone的“卖房管家-麦克风”\n允许访问您的手机麦克风"];
        
        NSString *title, *message, *otherStr;
        if (isCanOpen) {
            message = messageCan[type];
            otherStr = @"去设置";
        } else {
            otherStr = @"确定";
            message = messageNot[type];
        }
        title = titleArray[type];
        [UIAlertView bk_showAlertViewWithTitle:title message:message cancelButtonTitle:@"取消" otherButtonTitles:@[otherStr] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (isCanOpen && buttonIndex == 1) {
                dispatch_after(0.01, dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:url];
                });
            }
        }];
//        [UIAlertView alertViewWithTitle:title
//                                message:message
//                      cancelButtonTitle:@"取消"
//                      otherButtonTitles:@[otherStr]
//                              onDismiss:^(int buttonIndex, NSString *buttonTitle){
//                                  if (isCanOpen) {
//                                      dispatch_after(0.01, dispatch_get_main_queue(), ^{
//                                          [[UIApplication sharedApplication] openURL:url];
//                                      });
//                                  }
//                              }
//                               onCancel:^{
//                               }];
    }

    return isCan;
}

@end
