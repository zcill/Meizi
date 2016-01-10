//
//  ZCMainCell.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCMainCell.h"
#import "ZCMoreDefines.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZCMainCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customView];
    }
    return self;
}

- (void)customView {
    
    self.imageView = [[UIImageView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    
}

- (void)setModel:(ZCMainPageModel *)model {
    
    _model = model;
    
    CGFloat sizeCompare = 236.f/354.f;
    
    CGFloat sizeWidth = ScreenWidth / 2 - 15;
    CGFloat sizeHeight = sizeWidth / sizeCompare;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbImgUrl]];
    [self.imageView setFrame:CGRectMake(0, 0, sizeWidth, sizeHeight)];
    
    self.titleLabel.text = model.title;
    [self.titleLabel setFrame:CGRectMake(5, sizeHeight, sizeWidth - 5, 30)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    
    self.url = model.url;
}

@end
