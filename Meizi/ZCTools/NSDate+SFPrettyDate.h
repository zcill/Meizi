//
//  NSDate+SFPrettyDate.h
//  zhimasterBoss
//
//  Created by 朱立焜 on 15/12/17.
//  Copyright © 2015年 sharefun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SFPrettyDate)

#pragma mark - 获取时间日期相关
/**
 * 获取该月的第一天的日期
 */
- (NSDate *)begindayOfMonth;
+ (NSDate *)begindayOfMonth:(NSDate *)date;

/**
 * 获取该月的最后一天的日期
 */
- (NSDate *)lastdayOfMonth;
+ (NSDate *)lastdayOfMonth:(NSDate *)date;

#pragma mark - 时间格式相关
/**
    时间格式按照YYYY-MM-dd HH:mm:ss排布
 */
- (NSString *)formatDate:(NSDate *)date;
/**
    时间格式按照x天前、x小时前、x分钟前排布
 */
- (NSString *)prettyDate:(NSTimeInterval)timeInterval;

/**
    时间格式仅按照x天前排布
 */
- (NSString *)prettyDateForOnlyDay:(NSTimeInterval)timeInterval;

@end
