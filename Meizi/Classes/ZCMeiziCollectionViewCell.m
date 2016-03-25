//
//  ZCMeiziCollectionViewCell.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/27.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCMeiziCollectionViewCell.h"

@implementation ZCMeiziCollectionViewCell
#pragma mark - Accessors
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
@end
