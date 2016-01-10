//
//  ZCMeiziViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCMeiziViewController.h"
#import "ZCMainPageModel.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "ZCMainCell.h"
#import "ZCAdCell.h"
#import "ZCMoreDefines.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZCMeiziViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation ZCMeiziViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createCollectionView) name:@"Html_Data_Fetch_Completed" object:nil];
    
    [self initData];
    
}

- (void)initData {
    
    self.dataSource = [NSMutableArray array];
    
    [self parsingHtml];
    
}

- (void)parsingHtml {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.mzitu.com/"]];
    NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self parseHtml:htmlStr];
        
    });
    
}

- (void)parseHtml:(NSString *)htmlStr {
    
    TFHpple *xpathParser  = [[TFHpple alloc] initWithHTMLData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *array = [xpathParser searchWithXPathQuery:@"//li"];
    for (TFHppleElement *element in array) {
        
        if (element.children.count > 0) {
            for (TFHppleElement *subElement in element.children) {
                if ([subElement.tagName isEqualToString:@"a"]) {
                    if (subElement.content.length <= 0) {
                        for (TFHppleElement *subElementChildren in subElement.children) {
                            [_dataSource addObject:subElementChildren.attributes];
                        }
                    }
                }
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Html_Data_Fetch_Completed" object:nil];
    
}

#pragma mark - collectionView
- (void)createCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    flowLayout.itemSize = CGSizeMake(150, 300);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[ZCMainCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCMainCell class])];
    [self.collectionView registerClass:[ZCAdCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCAdCell class])];
    
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    ZCMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZCMainCell class]) forIndexPath:indexPath];
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    
    cell.model = [ZCMainPageModel modelWithDictionary:dict];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 300);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
