//
//  ZCSingleton.h
//  Meizi
//
//  Created by 朱立焜 on 16/2/3.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#ifndef ZCSingleton_h
#define ZCSingleton_h

#define singleton_interface(className) + (className *)shared##className;

#define singleton_implementation(className)\
static className *_instance;\
+(id)shared##className{\
if(!_instance){\
_instance=[[self alloc]init];\
}\
return _instance;\
}\
+(id)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t dispatchOnce;\
dispatch_once(&dispatchOnce, ^{\
_instance=[super allocWithZone:zone];\
});\
return _instance;\
}

#endif /* ZCSingleton_h */
