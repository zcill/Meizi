//
//  ZCLoginViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/17.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCLoginViewController.h"

@interface ZCLoginViewController ()

@end

@implementation ZCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)login:(UIButton *)sender {
    [self zc_resignFirsetResponder];
}

- (IBAction)registe:(UIButton *)sender {
    [self zc_resignFirsetResponder];
}

- (IBAction)see:(UIButton *)sender {
    [self zc_resignFirsetResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self zc_resignFirsetResponder];
}

- (void)zc_resignFirsetResponder {
    [_phoneNumberTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

@end
