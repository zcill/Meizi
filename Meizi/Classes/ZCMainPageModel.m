//
//  ZCMainPageModel.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCMainPageModel.h"

@implementation ZCMainPageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (ZCMainPageModel *)modelWithDictionary:(NSDictionary *)dict {
    
    ZCMainPageModel *model = [[ZCMainPageModel alloc] init];
    
    model.title = [dict objectForKey:@"alt"];
    model.thumbImgUrl = [dict objectForKey:@"data-original"];
    
    return model;
}

@end
