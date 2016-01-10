//
//  ZCMainPageModel.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCMainPageModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumbImgUrl;
@property (nonatomic, copy) NSString *url;

+ (ZCMainPageModel *)modelWithDictionary:(NSDictionary *)dict;

@end
