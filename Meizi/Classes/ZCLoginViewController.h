//
//  ZCLoginViewController.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/17.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registeButton;
@property (weak, nonatomic) IBOutlet UIButton *seeButton;

@end
