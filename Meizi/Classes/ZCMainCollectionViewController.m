//
//  ZCMainCollectionViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCMainCollectionViewController.h"
#import "ZCMainHeader.h"
#import "ZCMeiziDetailViewController.h"

@interface ZCMainCollectionViewController ()<UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate>

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.detailUrlDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [self getRealmPageData];
    
    // 设置布局
    RLMRealm *realm = [self getRealmPageData];
    [self setNaviBar];
    
    // 设置数据和CollectionView
    [self initData];
    [self setupCollectionView];
    
    // 设置上拉刷新和下拉刷新控件
    [self setRefreshControlWithRealm:realm];
}

#pragma mark - 懒加载
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

#pragma mark - 布局相关
- (RLMRealm *)getRealmPageData {
    
    // 读取数据库，查看上次看到的页码，直接赋值给self.page
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *allPageTag = [ZCMeiziPageTagRealm allObjects];
    if (allPageTag.count == 0) {
        self.page = 1;
    } else {
        
        ZCMeiziPageTagRealm *lastTagPageObject = [allPageTag lastObject];
        self.page = lastTagPageObject.page;
        
    }
    
    return realm;
    
}

- (void)setNaviBar {
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.95 green:0.92 blue:0.5 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                                      NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:14]
                                                                      }];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setRefreshControlWithRealm:(RLMRealm *)realm {
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
        
        // 如果用户拉到顶部去刷新，就删除数据库的首页妹子和页码表的数据
        [realm beginWriteTransaction];
        [realm deleteObjects:[ZCMeiziRealm allObjects]];
        [realm deleteObjects:[ZCMeiziPageTagRealm allObjects]];
        [realm commitWriteTransaction];
        [self initData];
    }];
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self initData];
        [self realm_add_pageTag_intoRealm:realm];
    }];
    
}

#pragma mark - 数据相关
- (void)initData {
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 请求缩略图和title数据
    [self parsingHtmlGetTitleAndThumbImg];
    
    // 请求下一个页面需要的url
    [self parsingHtmlGetDetailUrl];
    
    [self addMeiziDataIntoRealm];
}

// 从html源代码中抓取数据
- (void)parsingHtmlGetTitleAndThumbImg {
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.mzitu.com/page/%ld", (long)_page];
    
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
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.mzitu.com/page/%ld", (long)_page];
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

// 把妹子的数据放进本地数据库
- (void)addMeiziDataIntoRealm {
    
    RLMRealm *realm = [RLMRealm defaultRealm];

    [realm beginWriteTransaction];
    [self realm_update_inRealm:realm];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
//    NSLog(@"%@", realm.path);
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"local document path: %@", localPath);
}

/**
 *  把妹子的thumbImageUrl和title存进数据库
 *
 *  @param realm 数据库
 */
- (void)realm_update_inRealm:(RLMRealm *)realm {
    
    for (NSDictionary *dict in _dataSource) {
        
        ZCMeiziRealm *girlRealm = [[ZCMeiziRealm alloc] init];
        girlRealm.meiziTitle = dict[@"alt"];
        girlRealm.meiziImageUrl = dict[@"data-original"];
        girlRealm.meiziUrl = [[_detailUrlDict objectForKey:girlRealm.meiziTitle] objectForKey:@"href"];
        
        // 用于刷新列表的更新数据，防止插入相同的数据
        [realm addOrUpdateObject:girlRealm];
        
        // 两种方法更新条目，都可以使用，但是都要求在数据库的表中设置了主键
//        [ZCMeiziRealm createOrUpdateInRealm:realm withValue:girlRealm];
        
    }
    [realm commitWriteTransaction];
    
}

/**
 *  把每次用户阅读到的地方页码标记下来存进数据库
 *
 *  @param realm 数据库
 */
- (void)realm_add_pageTag_intoRealm:(RLMRealm *)realm {
    
    ZCMeiziPageTagRealm *tagPageObject = [[ZCMeiziPageTagRealm alloc] init];
    
    NSDate *currentDate = [NSDate date];
    tagPageObject.tagDate = [currentDate formatDate:currentDate];
    tagPageObject.page = _page;
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:tagPageObject];
    [realm commitWriteTransaction];
    
}

#pragma mark - CollectionView Delegate DelegateFlowOut And DataSource
- (void)setupCollectionView {
    
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44 + 49 + 20, 0);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = myGrayColor;
    
    [self.collectionView registerClass:[ZCMainCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCMainCell class])];
    [self.collectionView registerClass:[ZCAdView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ZCAdView class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    return self.dataSource.count;
    
    RLMResults *girls = [ZCMeiziRealm allObjects];
    return girls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZCMainCell class]) forIndexPath:indexPath];
    
//    NSDictionary *dict  = self.dataSource[indexPath.item];
    
    RLMResults *girls = [ZCMeiziRealm allObjects];
    
    cell.meiziRealm = girls[indexPath.item];

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"item--->%ld, row--->%ld, section--->%ld", (long)indexPath.item, (long)indexPath.row, (long)indexPath.section);
    NSLog(@"%@", indexPath);
    
    /*
    NSDictionary *dict = self.dataSource[indexPath.item];
    NSString *title = [dict objectForKey:@"alt"];
    NSString *url = [[_detailUrlDict objectForKey:title] objectForKey:@"href"];
    */
//    ZCMeiziRealm *meizi = self.dataSource[indexPath.item];
    
    /*
    ZCMeiziRealm *meizi = [ZCMeiziRealm allObjects][indexPath.item];
    ZCMainDetailViewController *detailVC = [[ZCMainDetailViewController alloc] init];
    detailVC.contentUrl = meizi.meiziUrl;
    detailVC.contentTitle = meizi.meiziTitle;
    detailVC.title = meizi.meiziTitle;
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
     */
    
    ZCMeiziRealm *meizi = [ZCMeiziRealm allObjects][indexPath.item];
    ZCMeiziDetailViewController *detailVC = [[ZCMeiziDetailViewController alloc] init];
    detailVC.contentUrl = meizi.meiziUrl;
    detailVC.contentTitle = meizi.meiziTitle;
    detailVC.title = meizi.meiziTitle;
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeCompare = 236.f/354.f;
    
    CGFloat sizeWidth = ScreenWidth / 2 - 15;
    CGFloat sizeHeight = sizeWidth / sizeCompare;
    
    return CGSizeMake(sizeWidth, sizeHeight + 30);
}

// collectionView头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *titles = @[@"翘臀豪乳酷刺青,气质女神夏美酱性感内衣写真", @"19岁美妞陆瓷晒大尺度裸私照", @"米妮大萌萌全裸入浴 自摸E奶叫人欲火焚身"];
    NSArray *images = @[@"http://pic.mmfile.net/2015/11/19x16.jpg", @"http://pic.mmfile.net/2014/09/15mt03.jpg", @"http://pic.mmfile.net/2015/09/20x06.jpg"];
    NSArray *urls = @[@"http://www.mzitu.com/53071", @"http://www.mzitu.com/28795", @"http://www.mzitu.com/48873"];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZCAdView *adView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ZCAdView class]) forIndexPath:indexPath];
    
        SDCycleScrollView *adCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        
        adCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        adCycleScrollView.titlesGroup = titles;
        adCycleScrollView.currentPageDotColor = [UIColor whiteColor];
        
        adCycleScrollView.imageURLStringsGroup = images;
        
        adCycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            
            ZCMeiziDetailViewController *detailVC = [[ZCMeiziDetailViewController alloc] init];
            detailVC.contentUrl = urls[currentIndex];
            detailVC.contentTitle = titles[currentIndex];
            detailVC.title = titles[currentIndex];
            detailVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        };
        
        [adView addSubview:adCycleScrollView];
        
        return adView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 180);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Umeng Analytics
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MainPageCollectionView"];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MainPageCollectionView"];
    
}


@end
