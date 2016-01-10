//
//  ZCMainCollectionViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCMainCollectionViewController.h"
#import "ZCMainHeader.h"

@interface ZCMainCollectionViewController ()<UICollectionViewDelegateFlowLayout>

/**
 *  包含了缩略图url和标题的数组
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  包含了detailUrl的数组
 */
@property (nonatomic, strong) NSMutableArray *detailUrlArray;
@property (nonatomic, strong) NSMutableDictionary *detailUrlDict;

@property (nonatomic, assign) NSInteger page;

@end

@implementation ZCMainCollectionViewController

// 懒加载
- (NSMutableArray *)dataSource {
    
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSource;
}
- (NSMutableArray *)detailUrlArray {
    if (_detailUrlArray == nil) {
        _detailUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _detailUrlArray;
}
- (NSMutableDictionary *)detailUrlDict {
    if (_detailUrlDict == nil) {
        _detailUrlDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _detailUrlDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.detailUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.detailUrlDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // 初始page默认为1
    self.page = 1;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self setupCollectionView];
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        self.page = 1;
        [self parsingHtmlGetTitleAndThumbImg];
    }];
    
//    [self.collectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self parsingHtmlGetTitleAndThumbImg];
    }];
    
}

// 请求数据
- (void)initData {
    
    // 请求缩略图和title数据
    [self parsingHtmlGetTitleAndThumbImg];
    
    // 请求下一个页面需要的url
    [self parsingHtmlGetDetailUrl];
}

- (void)parsingHtmlGetTitleAndThumbImg {
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.mzitu.com/page/%ld", self.page];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self parseHtml:htmlStr];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
        
    });
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

/**
 *  获取下一个页面需要的url
 */
- (void)parsingHtmlGetDetailUrl {
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.mzitu.com/page/%ld", self.page];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // parseHtml
    TFHpple *xpathParser  = [[TFHpple alloc] initWithHTMLData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *array = [xpathParser searchWithXPathQuery:@"//span"];
    for (TFHppleElement *element in array) {
        
        if (element.children.count > 0) {
            for (TFHppleElement *subElement in element.children) {
                
                if ([subElement.tagName isEqualToString:@"a"]) {
                    if (subElement.content.length > 0) {
                            
                        [_detailUrlArray addObject:subElement.attributes];
                        [_detailUrlDict setValue:subElement.attributes forKey:subElement.content];
                    }
                }
            }
        }
    }
    
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
    
}

#pragma mark - collectionView
- (void)setupCollectionView {
    
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44 + 49 + 20, 0);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = myGrayColor;
    
    [self.collectionView registerClass:[ZCMainCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCMainCell class])];
    [self.collectionView registerClass:[ZCAdCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCAdCell class])];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZCMainCell class]) forIndexPath:indexPath];
    
    NSDictionary *dict = self.dataSource[indexPath.item];
    
    cell.model = [ZCMainPageModel modelWithDictionary:dict];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"item--->%ld, row--->%ld, section--->%ld", indexPath.item, indexPath.row, indexPath.section);
    NSLog(@"%@", indexPath);
    
    NSDictionary *dict = self.dataSource[indexPath.item];
    NSString *title = [dict objectForKey:@"alt"];
    NSString *url = [[_detailUrlDict objectForKey:title] objectForKey:@"href"];
    
    ZCMainDetailViewController *detailVC = [[ZCMainDetailViewController alloc] init];
    detailVC.contentUrl = url;
    detailVC.contentTitle = title;
    detailVC.title = title;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeCompare = 236.f/354.f;
    
    CGFloat sizeWidth = ScreenWidth / 2 - 15;
    CGFloat sizeHeight = sizeWidth / sizeCompare;
    
    return CGSizeMake(sizeWidth, sizeHeight + 30);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
