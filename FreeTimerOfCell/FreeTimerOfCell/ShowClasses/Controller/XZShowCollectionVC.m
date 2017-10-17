//
//  XZShowCollectionVC.m
//  FreeTimerOfCell
//
//  Created by 夜风 on 2017/10/17.
//  Copyright © 2017年 夜风. All rights reserved.
//

#import "XZShowCollectionVC.h"
#import "XZFreeTimerCell.h"
#import "XZImageItemCell.h"

/**
 组别
 */
typedef enum : NSUInteger {
    XZCountdownSection = 0,    //倒计时组
    XZImageSection,            //图片组
} XZSectionType;

@interface XZShowCollectionVC ()

//日期
@property (nonatomic, copy) NSString *dateStr;
//是否更新日期
@property (nonatomic, assign) BOOL updateDate;

//图片数据源
@property (nonatomic, strong) NSArray <NSString *>*imageArray;

@end

@implementation XZShowCollectionVC
#pragma mark - getter
- (NSArray<NSString *> *)imageArray {
    if (_imageArray == nil) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (int i = 1; i < 6; i++) {
            [dataArray addObject:[NSString stringWithFormat:@"000%d.jpg",i]];
        }
        _imageArray = dataArray;
    }
    return _imageArray;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateStr = @"01:00:00:09";
    self.updateDate = YES;
    
    //注册Cell
    [self registerCell];
}

#pragma mark - custom
/**
 注册Cell
 */
- (void)registerCell {
    self.collectionView.contentInset = UIEdgeInsetsMake(10.0, 0.0, 20.0, 10.0);
    
    [XZFreeTimerCell registerCell:self.collectionView];
    [XZImageItemCell registerCell:self.collectionView];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section == XZCountdownSection) return 1;
    
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //释放定时器Cell
    if (indexPath.section == XZCountdownSection) {
        BOOL updateDate = self.updateDate;
        if (self.updateDate) {
            self.updateDate = NO;
        }
        return [XZFreeTimerCell cellWithCollectionView:collectionView atIndexPath:indexPath dateStr:self.dateStr updateDate:updateDate];
    }
    
    //图片Cell
    return [XZImageItemCell cellWithCollectionView:collectionView atIndexPath:indexPath imgName:self.imageArray[indexPath.item]];
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //释放定时器Cell
    if (indexPath.section == XZCountdownSection) {
        return [XZFreeTimerCell sizeOfCell];
    }
    
    //图片Cell
    return [XZImageItemCell sizeOfCell];
}

@end
