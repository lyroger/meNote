//
//  MNNetConfigure.h
//  MeNote
//
//  Created by luoyan on 2017/4/20.
//  Copyright © 2017年 roger. All rights reserved.
//

#ifndef MNNetConfigure_h
#define MNNetConfigure_h

#define isTrueEnvironment 1 //正式发布
#define isTestEnvironment 1 //测试环境


#if isTrueEnvironment
//正式环境的环境类型
#define kServerHost                 @"http://121.43.178.45:8080"
#define kServerCurrentPath          @"/tfin/"
#define kServerPushNotificationHost @"http://121.196.199.36:8080/push"
#define kJPushAPPKey                @"3612ee3156da4290d136665c"
#else

#if isTestEnvironment
// 测试环境
#define kServerHost                 @"http://172.18.84.243:8080"
#define kServerCurrentPath          @"/tfin/"
#define kServerPushNotificationHost @"http://172.18.84.243:8080/push"
#define kJPushAPPKey                @"3612ee3156da4290d136665c"
#endif

#endif

#endif /* MNNetConfigure_h */
