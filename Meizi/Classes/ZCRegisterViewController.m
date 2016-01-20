//
//  ZCRegisterViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/19.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCRegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <CRToast/CRToast.h>
#import <ChameleonFramework/Chameleon.h>

@interface ZCRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFIeld;

@end

@implementation ZCRegisterViewController

#pragma mark - private extension
- (void)zc_crtoast_showWithInfo:(NSString *)info color:(UIColor *)color{
    
    NSDictionary *options = @{
                              kCRToastTextKey : info,
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : color,
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

- (IBAction)register:(UIButton *)sender {
    
    AVUser *user = [AVUser user];
    user.username = self.phoneNumberTextField.text;
    user.password = self.passwordTextFIeld.text;
    
    if (![self isValidateMobile:self.phoneNumberTextField.text]) {
        [self zc_crtoast_showWithInfo:@"手机号码格式不正确" color:FlatRed];
        return;
    }
    //    if (![self isValidPassword:self.passwordTextField.text]) {
    //        [self zc_crtoast_showWithInfo:@"密码格式不正确"];
    //        return;
    //    }
    
    [user setObject:self.phoneNumberTextField.text forKey:@"phone"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            [self zc_crtoast_showWithInfo:@"注册成功" color:FlatGreenDark];
            
        } else {
            
            [self zc_crtoast_showWithInfo:error.description color:FlatRed];
            
        }
        
    }];
    
}

- (IBAction)seeWithoutRegister:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextFIeld resignFirstResponder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
