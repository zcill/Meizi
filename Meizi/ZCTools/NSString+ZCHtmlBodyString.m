//
//  NSString+ZCHtmlBodyString.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "NSString+ZCHtmlBodyString.h"

@implementation NSString (ZCHtmlBodyString)

/**
 *  通过一个网址获取网页源代码
 *
 *  @param url 网址
 *
 *  @return 网页源代码string
 */
+ (NSString *)getHtmlBodyStringWithUrl:(NSURL *)url {
    
    // 用NSData将网页源代码获取到
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // 将data转为string
    NSString *htmlBodyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return htmlBodyString;
}

/**
 *  传入正则表达式，返回结果数组
 *
 *  @param regular 需要匹配的正则表达式
 *
 *  @return 结果数组
 */
- (NSMutableArray *)getFeedBackArrayWithSubstringByRegular:(NSString *)regular {
    
    NSString * reg=regular;
    
    NSRange r= [self rangeOfString:reg options:NSRegularExpressionSearch];
    
    NSMutableArray *arr=[NSMutableArray array];
    
    if (r.length != NSNotFound && r.length != 0) {
        
        int i = 0;
        
        while (r.length != NSNotFound && r.length != 0) {
            
//            NSLog(@"index = %d regIndex = %ld loc = %ld",(++i),r.length,r.location);
            
            NSString* substr = [self substringWithRange:r];
            
//            NSLog(@"substr = %@",substr);
            
            [arr addObject:substr];
            
            NSRange startr=NSMakeRange(r.location+r.length, [self length]-r.location-r.length);
            
            r=[self rangeOfString:reg options:NSRegularExpressionSearch range:startr];
        }
    }
    return arr;
}

/**
 *  通过正则表达式匹配手机号是否格式正确
 *
 *  @param telNumber 手机号码
 *
 *  @return 是否正确
 */
+ (BOOL)checkTelNumber:(NSString *) telNumber {
    NSString *pattern = @"^1+[3578]+d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[a-zA-Z一-龥]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[0-9]{12}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
    
}

@end
