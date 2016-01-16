//
//  ZCCategoryViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/6.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCCategoryViewController.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UMengAnalytics/MobClick.h>

#import <Realm/Realm.h>

@interface ZCCategoryViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZCCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 标题是前24个string
    self.dataArray = [NSMutableArray array];
    
    [self parsingHtml];
    
}

- (void)parsingHtml {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.mzitu.com/"]];
    NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.dataArray = [self parseHtml:htmlStr];
        for (NSDictionary *dict in _dataArray) {
            NSString *title = [dict objectForKey:@"alt"];
            NSString *dataOriginal = [dict objectForKey:@"data-original"];
            NSString *width = [dict objectForKey:@"width"];
            NSString *height = [dict objectForKey:@"height"];
            
            NSLog(@"title - %@ \ndataOriginal - %@ \nwidth - %@ \n height - %@", title, dataOriginal, width, height);
        }
    });
    
}
                          
- (NSMutableArray *)parseHtml:(NSString *)htmlStr {
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *array = [xpathParser searchWithXPathQuery:@"//li"];
    for (TFHppleElement *element in array) {
        if (element.children.count > 0) {
            for (TFHppleElement *subElement in element.children) {
                if ([subElement.tagName isEqualToString:@"a"]) {
                    
                    if (subElement.content.length <= 0) {
                        
                        for (TFHppleElement *subElementChildren in subElement.children) {
                            
                            [_dataArray addObject:subElementChildren.attributes];
                            
                        }
                    }
                }
            }
        }
    }
    
    NSLog(@"%@", _dataArray);
//    NSLog(@"%ld", _dataArray.count);
    
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Umeng Analytics
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CategoryPage"];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CategoryPage"];
    
}

@end
