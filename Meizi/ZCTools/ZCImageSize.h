//
//  ZCImageSize.h
//  Meizi
//
//  Created by 朱立焜 on 16/2/3.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCSingleton.h"

@interface ZCImageSize : NSObject

singleton_interface(ZCImageSize)

+ (CGSize)downloadImageSizeWithURL:(id)imageURL;

+ (CGSize)getImageSizeFromURL:(NSString *)url;

@end
