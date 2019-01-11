//
//  RefreshCatGifHeader.m
//  MeiyaoniKH
//
//  Created by Jason on 17/5/28.
//  Copyright © 2017年 ainisi. All rights reserved.
//

#import "RefreshCatGifHeader.h"

@implementation RefreshCatGifHeader

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 0; i<=72; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"2_000%zd", i]];
//        [idleImages addObject:image];
//    }
//    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (NSUInteger i = 80; i<=93; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"2_000%zd", i]];
//        [refreshingImages addObject:image];
//    }
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    
    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
//    self.stateLabel.hidden = YES;
    
    self.lastUpdatedTimeLabel.hidden = YES;
    
    self.automaticallyChangeAlpha = YES;
}


@end
