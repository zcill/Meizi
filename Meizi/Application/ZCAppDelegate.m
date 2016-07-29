//
//  AppDelegate.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCAppDelegate.h"
#import "ZCTabBar.h"
#import "ZCLoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <UMMobClick/MobClick.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface ZCAppDelegate ()

@end

@implementation ZCAppDelegate

- (void)confirmTouchID {
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证Touch ID" reply:^(BOOL success, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"%d", success);
            } else {
                NSLog(@"%@", [self getAuthErrorDescription:error.code]);
            }
        }];
        
    } else {
        NSLog(@"%@", [self getAuthErrorDescription:error.code]);
    }
    
}

- (NSString *)getAuthErrorDescription:(NSInteger)code
{
    NSString *msg = @"";
    switch (code) {
        case LAErrorTouchIDNotEnrolled:
            //认证不能开始,因为touch id没有录入指纹.
            msg = TouchIDNotEnrolled;
            break;
        case LAErrorTouchIDNotAvailable:
            //认证不能开始,因为touch id在此台设备尚是无效的.
            msg = TouchIDNotAvailable;
            break;
        case LAErrorPasscodeNotSet:
            //认证不能开始,因为此台设备没有设置密码.
            msg = TouchIDPasscodeNotSet;
            break;
        case LAErrorSystemCancel:
            //认证被系统取消了,例如其他的应用程序到前台了
            msg = TouchIDSystemCancel;
            break;
        case LAErrorUserFallback:
            //认证被取消,因为用户点击了fallback按钮(输入密码).
            msg = TouchIDUserFallback;
            break;
        case LAErrorUserCancel:
            //认证被用户取消,例如点击了cancel按钮.
            msg = TouchIDUserCancel;
            break;
        case LAErrorAuthenticationFailed:
            //认证没有成功,因为用户没有成功的提供一个有效的认证资格
            msg = TouchIDAuthenticationFailed;
            break;
        default:
            break;
    }
    return msg;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化LeanCloud
    [self setLeanCloudSDK];
    
    // 设置友盟统计
    [self setUmengAnalytics];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
    
    // 如果第一次进入app，显示登录界面
    if (![AVUser currentUser]) {
        ZCLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"ZCLoginViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"ZCLoginViewController"];
        [self.window addSubview:loginVC.view];
        [self.window setRootViewController:loginVC];
        
    } else {
        
        ZCTabBar *tabBar = [[ZCTabBar alloc] init];
        [self.window addSubview:tabBar.view];
        [self.window setRootViewController:tabBar];
        
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

/**
 *  集成LeanCloudSDK
 */
- (void)setLeanCloudSDK {
    
    // 初始化LeanCloud
    // AppID和AppKey存放在pch文件中
    [AVOSCloud setApplicationId:LeanCloudAppID clientKey:LeanCloudAppKey];
    [AVOSCloud setAllLogsEnabled:YES];
    
}

/**
 *  集成友盟统计功能
 */
- (void)setUmengAnalytics {
    
    // 开启友盟统计功能
    UMAnalyticsConfig *config = [[UMAnalyticsConfig alloc] init];
    config.appKey = UmengAppKey;
    config.ePolicy = BATCH;
    config.channelId = nil;
    
    [MobClick startWithConfigure:config];
    
    // 获取Xcode工程的Version号而不是build号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    // 打开调试模式
    [MobClick setLogEnabled:YES];
    
}

/** 友盟-实现页面的统计需要在每个View中配对调用如下方法
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];//("PageOne"为页面名称，可自定义)
 }

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
    
}
 */



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
