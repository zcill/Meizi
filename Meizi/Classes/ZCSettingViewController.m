//
//  ZCSettingViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCSettingViewController.h"
#import <UMengAnalytics/MobClick.h>

@interface ZCSettingViewController ()

@end

@implementation ZCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.95 green:0.92 blue:0.5 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                                      NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:14]
                                                                      }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Umeng Analytics
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SettingPage"];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SettingPage"];
    
}

@end
