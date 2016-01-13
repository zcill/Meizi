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
    
    model.title = [dict objectForKey:@"meiziTitle"];
    model.thumbImgUrl = [dict objectForKey:@"meiziImageUrl"];
    model.url = [dict objectForKey:@"meiziUrl"];
    
    return model;
}

@end
