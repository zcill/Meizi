//
//  NSString+ZCHtmlBodyString.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZCHtmlBodyString)

/**
 *  通过一个网址获取网页源代码
 *
 *  @param url 网址
 *
 *  @return 网页源代码string
 */
+ (NSString *)getHtmlBodyStringWithUrl:(NSURL *)url;

@end
