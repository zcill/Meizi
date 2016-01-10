//
//  ZCMainCell.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCMainPageModel.h"

@interface ZCMainCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) ZCMainPageModel *model;

@end
