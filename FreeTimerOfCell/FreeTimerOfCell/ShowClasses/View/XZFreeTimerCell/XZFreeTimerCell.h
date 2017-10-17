//
//  XZFreeTimerCell.h
//  FreeTimerOfCell
//
//  Created by 夜风 on 2017/10/17.
//  Copyright © 2017年 夜风. All rights reserved.
//

#pragma mark ***释放定时器Cell***

#import <UIKit/UIKit.h>

@interface XZFreeTimerCell : UICollectionViewCell

/**
 注册"释放定时器Cell"
 
 @param collectionView 集合视图
 */
+ (void)registerCell:(UICollectionView *)collectionView;

/**
 实例化"释放定时器Cell"
 
 @param collectionView 集合视图
 @param atIndexPath 位置
 @param dateStr 日期(00:00:00:00)
 @param updateDate 是否更新日期
 @return self
 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath dateStr:(NSString *)dateStr updateDate:(BOOL)updateDate;

/**
 获得"释放定时器Cell"大小
 */
+ (CGSize)sizeOfCell;

@end
