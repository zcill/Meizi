//
//  ZCMainViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCMainViewController.h"
#import "NSString+ZCHtmlBodyString.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "ZCMoreDefines.h"

@interface ZCMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPicWithUrlString:@"http://www.mzitu.com/56508" picNumber:42];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 350, 500)];
    [image sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.row]]];
    [cell addSubview:image];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)getPicWithUrlString:(NSString *)urlString picNumber:(NSInteger)picNumber {
    
    NSString *str = @"";
    self.dataSource = [NSMutableArray array];
    
    for (int i = 1; i < picNumber + 1; i++) {
        str = [NSString getHtmlBodyStringWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d", urlString, i]]];
        NSArray *arr = [str getFeedBackArrayWithSubstringByRegular:@"[a-zA-z]+://[^\\s]*jpe?g"];
        NSString *string = [arr objectAtIndex:0];
        NSLog(@"%@", string);
        [self.dataSource addObject:string];
    }
    
    NSLog(@"%@", self.dataSource);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//    NSArray *arr = [str getFeedBackArrayWithSubstringByRegular:@"img[src~=(?i)\\.(png|jpe?g)]"];



//    CGRect frame = self.view.frame;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:string]];

//    [self.view addSubview:imageView];

//    NSLog(@"%@", arr);

@end
