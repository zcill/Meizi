//
//  define.h
//  
//
//  Created by 朱立焜 on 15/9/1.
//
//

#ifndef _define_h
#define _define_h
#endif

#pragma mark ----------- 尺寸宏
// 状态栏高度
#define StatusBarHeight 20
// 导航栏高度
#define NavigationBarHeight 44

#define NavigationBarIcon 20
// tabBar高度
#define TabBarHeight 49

#define TabBarIcon 40
// 获取屏幕宽高
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#pragma mark ------------ 系统宏
// 获取iOS系统版本
#define GetSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

// 获取当前语言
#define CurrentLangage ([[NSLocale preferredLangages] objectAtIndex:0])

#pragma mark ------------ 颜色宏
// 经常使用的灰色
#define myGrayColor [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1]
// 经常使用的淡灰色
#define myLightGrayColor [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1]
// 背景色
#define myBackgroundColor [UIColor colorWithRed:242/255.f green:236/255.f blue:231/255.f alpha:1]
// 转化RGB颜色
#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#define rgba(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]


