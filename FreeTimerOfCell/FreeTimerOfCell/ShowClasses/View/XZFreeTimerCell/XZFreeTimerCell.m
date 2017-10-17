//
//  XZFreeTimerCell.m
//  FreeTimerOfCell
//
//  Created by 夜风 on 2017/10/17.
//  Copyright © 2017年 夜风. All rights reserved.
//

#import "XZFreeTimerCell.h"
#import "Define.h"

@interface XZFreeTimerCell ()

//天数Label
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
//小时Label
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
//分钟Label
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
//秒数Label
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

//总秒数
@property (nonatomic, assign) NSInteger totalSecondNum;
//定时器
@property (nonatomic, weak) NSTimer *timer;

@end


@implementation XZFreeTimerCell
#pragma mark - system
/**
 当视图即将加入父视图时 / 当视图即将从父视图移除时调用
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview && self.timer) {
        //销毁定时器
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
 释放内存
 */
- (void)dealloc {
    NSLog(@">>>>>>释放定时器Cell<<<<<<");
}

#pragma mark - 注册Cell
/**
 注册"释放定时器Cell"

 @param collectionView 集合视图
 */
+ (void)registerCell:(UICollectionView *)collectionView {
    if ((!collectionView) ||
        (![collectionView isKindOfClass:[UICollectionView class]])) {
        return;
    }
    
    NSString *cellName = NSStringFromClass(self);
    [collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:cellName];
}

#pragma mark - init
/**
 实例化"释放定时器Cell"
 
 @param collectionView 集合视图
 @param atIndexPath 位置
 @param dateStr 日期(00:00:00:00)
 @param updateDate 是否更新日期
 @return self
 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath dateStr:(NSString *)dateStr updateDate:(BOOL)updateDate {
    //1.实例化
    XZFreeTimerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self) forIndexPath:atIndexPath];
    
    //2.重置时期时，刷新数据
    if (cell && updateDate) {
        [cell reloadDataWithDateStr:dateStr];
    }

    return cell;
}

#pragma mark - custom
/**
 刷新数据
 
 @param dateStr 日期(00:00:00:00)
 */
- (void)reloadDataWithDateStr:(NSString *)dateStr {
    //1.校验
    self.totalSecondNum = 0;
    if (!dateStr.length) {
        [self reloadUI]; return;
    }
    
    //2.计算总秒数
    //2.1.校验日期格式是否合法
    NSArray *dateArray = [dateStr componentsSeparatedByString:@":"];
    if (dateArray.count != 4) {
        [self reloadUI]; return;
    }
    
    //2.2.计算
    //天
    NSInteger dayNum = [dateArray[0] integerValue];
    //小时
    NSInteger hourNum = [dateArray[1] integerValue];
    //分
    NSInteger  minuteNum = [dateArray[2] integerValue];
    //总秒数
    self.totalSecondNum = dayNum*24*60*60 + hourNum*60*60 + minuteNum*60 + [dateArray[3] integerValue];
    
    //3.刷新UI
    [self reloadUI];
    
    //4.开启定时器
    [self startTimer];
}

/**
 刷新UI
 */
- (void)reloadUI {
    //1.校验总秒数
    if (self.totalSecondNum <= 0) {
        self.dayLabel.text = @"0";
        self.hourLabel.text = @"00";
        self.minuteLabel.text = @"00";
        self.secondLabel.text = @"00";
        
        return;
    }
    
    //2.刷新UI
    //天数
    NSInteger day = (self.totalSecondNum / (3600 * 24));
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",day];
    
    //小时数
    NSInteger hour = (self.totalSecondNum / 3600) % 24;
    self.hourLabel.text = [NSString stringWithFormat:@"%02ld",hour];
    
    //分数
    NSInteger minute = (self.totalSecondNum / 60) % 60;
    self.minuteLabel.text = [NSString stringWithFormat:@"%02ld",minute];
    
    //秒数
    NSInteger second = self.totalSecondNum % 60;
    self.secondLabel.text = [NSString stringWithFormat:@"%02ld",second];
    
    //3.总秒数减一
    self.totalSecondNum -= 1;
    if (self.totalSecondNum <= 0) {
        self.totalSecondNum = 0;
    }
}

#pragma mark 开启定时器
/**
 开启定时器
 */
- (void)startTimer {
    //1.校验，只实例化一次
    if (self.timer) return;
    
    //2.实例化定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(reloadUI) userInfo:nil repeats:YES];
    //3.添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}

#pragma mark - size
/**
 获得"释放定时器Cell"大小
 */
+ (CGSize)sizeOfCell {
    return CGSizeMake(kScreenWidth, 30.0);
}


@end
