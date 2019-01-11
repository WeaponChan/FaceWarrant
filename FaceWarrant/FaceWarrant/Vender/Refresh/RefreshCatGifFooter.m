//
//  RefreshCatGifHeader.m
//  MeiyaoniKH
//
//  Created by Jason on 17/5/26.
//  Copyright © 2017年 ainisi. All rights reserved.
//

#import "RefreshCatGifFooter.h"

@implementation RefreshCatGifFooter

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置文字
    [self setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"-------- 我也是有底线的 --------" forState:MJRefreshStateNoMoreData];
    
    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 0; i<=38; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"1_000%zd", i]];
//        [idleImages addObject:image];
//    }
//    [self setImages:idleImages forState:MJRefreshStateRefreshing];
    
    self.automaticallyHidden = YES;
    
}


@end
