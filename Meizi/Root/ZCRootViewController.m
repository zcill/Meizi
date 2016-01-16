//
//  ZCRootViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCRootViewController.h"

@interface ZCRootViewController ()

@end

@implementation ZCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.95 green:0.92 blue:0.5 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                                      NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:14]
                                                                      }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
