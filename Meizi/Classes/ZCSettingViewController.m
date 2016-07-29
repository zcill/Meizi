//
//  ZCSettingViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCSettingViewController.h"
#import <UMMobClick/MobClick.h>
#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImage/SDImageCache.h>
#import <CRToast/CRToast.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import "ZCLoginViewController.h"

@interface ZCSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation ZCSettingViewController

- (void)zc_crtoast_showWithInfo:(NSString *)info {
    
    NSDictionary *options = @{
                              kCRToastTextKey : info,
                              kCRToastNotificationTypeKey : @(CRToastTypeStatusBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : FlatGreenDark,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop)
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    DLog(@"Completed");
                                }];
    
}

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
    
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        
    } else if (indexPath.section == 2) {
        
        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"您确定要清除缓存吗"];
        [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        
        [actionSheet bk_setDestructiveButtonWithTitle:@"清除缓存" handler:^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self clearCache];
            });
        }];
        
        [actionSheet showInView:self.view];
        
    } else if (indexPath.section == 3) {
        
    }
    
}

// 清除缓存
- (void)clearCache {
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
        [self zc_crtoast_showWithInfo:@"清除缓存完成"];
        
    }];
    // 缓存
    float cacheSize = [[SDImageCache sharedImageCache] getSize];
    float cacheSizeMB = cacheSize / (1024*1024);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cacheLabel.text = [NSString stringWithFormat:@"(%.2fMB)", cacheSizeMB];
        [self.tableView reloadData];
    });
}

// 登出
- (IBAction)signOut:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"登出账户就无法云端同步您喜欢的妹子咯"];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    
    [actionSheet bk_setDestructiveButtonWithTitle:@"登出账户" handler:^{
        [AVUser logOut];
        
        ZCLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"ZCLoginViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"ZCLoginViewController"];
        [self presentViewController:loginVC animated:YES completion:nil];
    }];
    
    [actionSheet showInView:self.view];
    
}

#pragma mark - Umeng Analytics
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 友盟
    [MobClick beginLogPageView:@"SettingPage"];
    
    // 缓存
    float cacheSize = [[SDImageCache sharedImageCache] getSize];
    float cacheSizeMB = cacheSize / (1024*1024);
    self.cacheLabel.text = [NSString stringWithFormat:@"(%.2fMB)", cacheSizeMB];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SettingPage"];
    
}

@end
