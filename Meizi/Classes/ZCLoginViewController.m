//
//  ZCLoginViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/17.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCLoginViewController.h"
#import "ZCAppDelegate.h"
#import "ZCTabBar.h"
#import "ZCRegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <CRToast/CRToast.h>
#import <ChameleonFramework/Chameleon.h>

@interface ZCLoginViewController ()

@end

@implementation ZCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - private extension
- (void)zc_crtoast_showWithInfo:(NSString *)info {
    
    NSDictionary *options = @{
                              kCRToastTextKey : info,
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : FlatRedDark,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop)
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
    
}

- (IBAction)login:(UIButton *)sender {
    
    if (![self isValidateMobile:self.phoneNumberTextField.text]) {
        [self zc_crtoast_showWithInfo:@"手机号码格式不正确"];
        return;
    }
    if (![self isValidPassword:self.passwordTextField.text]) {
        [self zc_crtoast_showWithInfo:@"密码格式不正确"];
        return;
    }
    
    // 判断帐号密码是否匹配
    [AVUser logInWithUsernameInBackground:self.phoneNumberTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
        
        if (!error) {
            
            [self zc_resignFirsetResponder];
            [self zc_crtoast_showWithInfo:@"登录成功"];
            
            // 设置AVInstallation
            AVInstallation *install = [AVInstallation currentInstallation];
            install[@"user"] = user;
            [install saveInBackground];
            
            [self zc_takeInMainPage];
            
        } else {
            [self zc_crtoast_showWithInfo:@"登录失败"];
            NSLog(@"%@", error.description);
        }
        
    }];
    
}

- (void)zc_takeInMainPage {
    
    ZCAppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    if ([appdelegate.window.rootViewController isKindOfClass:[ZCLoginViewController class]]) {
        
        ZCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        ZCTabBar *tabBar = [[ZCTabBar alloc] init];
        appDelegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        appDelegate.window.backgroundColor = [UIColor whiteColor];
        appDelegate.window.rootViewController = tabBar;
        [appDelegate.window makeKeyAndVisible];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)registe:(UIButton *)sender {
    [self zc_resignFirsetResponder];
    
    ZCRegisterViewController *registerVC = [[UIStoryboard storyboardWithName:@"ZCLoginViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"ZCRegisterViewController"];
    // 设置模态翻转动画效果
    registerVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (IBAction)see:(UIButton *)sender {
    [self zc_resignFirsetResponder];
    [self zc_takeInMainPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self zc_resignFirsetResponder];
}

- (void)zc_resignFirsetResponder {
    [_phoneNumberTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

#pragma mark - predicate check phone number format
// 6-18位英文字母和数字组合
-(BOOL)isValidPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

// 用正则表达式去匹配号码格式
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

@end
