//
//  ZCMeiziDetailViewController.m
//  Meizi
//
//  Created by 朱立焜 on 16/1/27.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCMeiziDetailViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "ZCMeiziCollectionViewCell.h"
#import <Realm/Realm.h>
#import "NSString+ZCHtmlBodyString.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZCMeiziRealm.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <UMMobClick/MobClick.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import "ZCMoreDefines.h"
#import "ZCImageSize.h"
#define CELL_COUNT 30
#define CELL_IDENTIFIER @"ZCMeiziCollectionViewCell"

@interface ZCMeiziDetailViewController ()<CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, IDMPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ZCMeiziDetailViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.headerHeight = 5;
        layout.footerHeight = 5;
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 15;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = myLightGrayColor;
        [_collectionView registerClass:[ZCMeiziCollectionViewCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

- (NSMutableArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cellSizes;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSource;
}

- (void)getPicWithUrlString:(NSString *)urlString picNumber:(NSInteger)picNumber {
    
    NSString *str = @"";
    
    for (int i = 1; i < picNumber + 1; i++) {
        
        str = [NSString getHtmlBodyStringWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d", urlString, i]]];
        if (![str isEqualToString:@""]) {
            NSArray *arr = [str getFeedBackArrayWithSubstringByRegular:@"[a-zA-z]+://[^\\s]*jpe?g"];
            NSString *string = [arr objectAtIndex:0];
            [_dataSource addObject:string];
            
            /*
            UIImage *tmpImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]];
            CGSize imgSize = CGSizeMake(tmpImage.size.width, tmpImage.size.height);
            DLog(@"%@", NSStringFromCGSize(imgSize));
            [self.cellSizes addObject:[NSValue valueWithCGSize:imgSize]];
             */
            
            CGSize imgSize = [ZCImageSize downloadImageSizeWithURL:[NSURL URLWithString:string]];
//            CGSize imgSize = [ZCImageSize getImageSizeFromURL:string];
            DLog(@"string:%@ ----- imgSize:%@", string, NSStringFromCGSize(imgSize));
            
            
            [self.cellSizes addObject:[NSValue valueWithCGSize:imgSize]];
            
        }
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"meiziUrl == %@", self.contentUrl];
    RLMResults *result = [ZCMeiziRealm objectsWithPredicate:pred];
    
    if (result.count != 0) {
        ZCMeiziRealm *meiziRealm = [result objectAtIndex:0];
        
        if (meiziRealm.allMeiziImgUrl.count == 0) {
            
            for (NSString *urlString in _dataSource) {
                
                ZCMeiziDetailStringRealm *detailRealm = [[ZCMeiziDetailStringRealm alloc] init];
                
                detailRealm.imgUrlString = urlString;
                
                [realm beginWriteTransaction];
                [realm addOrUpdateObject:detailRealm];
                [meiziRealm.allMeiziImgUrl addObject:detailRealm];
                [realm commitWriteTransaction];
            }
            
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [SVProgressHUD dismiss];
    });
}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [SVProgressHUD setForegroundColor:FlatSkyBlueDark];
    [SVProgressHUD showWithStatus:@"马上看妹子"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getPicWithUrlString:self.contentUrl picNumber:60];
    });

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
//    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
    layout.columnCount = 2;
}

#pragma mark - PhotoBrowser
- (void)showPhotoWithIndexPath:(NSIndexPath *)indexPath {
    
//    NSMutableArray *photoUrl = [NSMutableArray array];
    
//    for (NSString *url in _dataSource) {
    
//        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:url]];
//        [photoUrl addObject:photo];
//    }
    
//    IDMPhotoBrowser *photoBrowser = [[IDMPhotoBrowser alloc] initWithPhotos:photoUrl animatedFromView:self.collectionView];
    IDMPhotoBrowser *photoBrowser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:@[_dataSource[indexPath.item]]];
    photoBrowser.delegate = self;
    photoBrowser.usePopAnimation = YES;
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCMeiziCollectionViewCell *cell =
    (ZCMeiziCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.item]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showPhotoWithIndexPath:indexPath];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.cellSizes[indexPath.item % 4] CGSizeValue];
    return [self.cellSizes[indexPath.item] CGSizeValue];
}

#pragma mark - Umeng Analytics
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DetailCollectionView"];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DetailPageCollectionView"];
    [SVProgressHUD dismiss];
}


@end
