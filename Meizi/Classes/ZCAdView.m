//
//  ZCAdView.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/11.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCAdView.h"
#import "ZCMoreDefines.h"

@implementation ZCAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customView];
    }
    return self;
}

- (void)customView {
    
    self.backgroundColor = [UIColor blueColor];
    
    SDCycleScrollView *adCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, ScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"Icon-60@2x.png"]];
    
    adCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    adCycleScrollView.titlesGroup = self.titleArray;
    adCycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    [self addSubview:adCycleScrollView];
}


@end
