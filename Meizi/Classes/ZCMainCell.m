//
//  ZCMainCell.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCMainCell.h"
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
    self.contentView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    
}

- (void)setModel:(ZCMainPageModel *)model {
    
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbImgUrl]];
    [self.imageView setFrame:CGRectMake(0, 0, 150, 300)];
    
    self.titleLabel.text = model.title;
    [self.titleLabel setFrame:CGRectMake(0, 260, 150, 40)];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.url = model.url;
}

@end
