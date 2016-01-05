//
//  NSString+ZCHtmlBodyString.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "NSString+ZCHtmlBodyString.h"

@implementation NSString (ZCHtmlBodyString)

+ (NSString *)getHtmlBodyStringWithUrl:(NSURL *)url {
    
    // 用NSData将网页源代码获取到
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // 将data转为string
    NSString *htmlBodyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return htmlBodyString;
}

@end
