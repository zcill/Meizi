//
//  ZCAdView.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/11.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface ZCAdView : UICollectionReusableView<SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end
