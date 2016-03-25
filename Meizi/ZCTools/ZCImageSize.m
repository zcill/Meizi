//
//  ZCImageSize.m
//  Meizi
//
//  Created by 朱立焜 on 16/2/3.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCImageSize.h"
#import <SDWebImage/SDImageCache.h>
#import <ImageIO/ImageIO.h>

@implementation ZCImageSize

singleton_implementation(ZCImageSize)

+ (id)diskImageDataBySearchingAllPathsForKey:(id)key {
    return nil;
}

+ (CGSize)downloadImageSizeWithURL:(id)imageURL {
    
    NSURL *url = nil;
    if ([imageURL isKindOfClass:[NSURL class]]) {
        url = imageURL;
    }
    if ([imageURL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:imageURL];
    }
    if (url == nil) {
        return CGSizeZero;
    }
    
    NSString *absoluteString = url.absoluteString;
    
#ifdef dispatch_main_sync_safe
    
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString]) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if (!image) {
            NSData *data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:url.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if (image) {
            return image.size;
        }
    }
    
#endif
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *pathExtension = [url.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if ([pathExtension isEqualToString:@"png"]) {
        size = [self downloadPNGImageSizeWithRequest:request];
    } else if ([pathExtension isEqualToString:@"gif"]) {
        size = [self downloadGIFImageSizeWithRequest:request];
    } else {
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:nil];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            
#ifdef dispatch_main_sync_safe
            
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:url.absoluteString toDisk:YES];
            
#endif
            size = image.size;
        }
    }
    
    return size;
}


+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}



+ (CGSize)getImageSizeFromURL:(NSString *)url {
    
    //    NSURL *imageFileUrl = [NSURL fileURLWithPath:@""];
    NSURL *imageFileUrl = [NSURL URLWithString:url];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)imageFileUrl, NULL);
    if (imageSource == NULL) {
        // Error loading img
        return CGSizeZero;
    }
    
    CGFloat width = 0.0f, height = 0.0f;
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    
    CFRelease(imageSource);
    
    if (imageProperties != NULL) {
        
        CFNumberRef widthNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
        if (widthNum != NULL) {
            CFNumberGetValue(widthNum, kCFNumberCGFloatType, &width);
        }
        
        CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
        if (heightNum != NULL) {
            CFNumberGetValue(heightNum, kCFNumberCGFloatType, &height);
        }
        
        // check orientation and flip size if required
        CFNumberRef orientationNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation);
        if (orientationNum != NULL) {
            int orientation;
            CFNumberGetValue(orientationNum, kCFNumberIntType, &orientationNum);
            if (orientation > 4) {
                CGFloat temp = width;
                width = height;
                height = temp;
            }
            
        }
        
        CFRelease(imageProperties);
    }
    
    NSLog(@"image dimensions: %.0f x %.0f px", width, height);
    
    return CGSizeMake(width, height);
}



@end
