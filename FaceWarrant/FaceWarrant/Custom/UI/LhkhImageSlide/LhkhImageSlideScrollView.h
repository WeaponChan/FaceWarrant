//
//  LhkhImageSlideScrollView.h
//  LhkhCommentList
//
//  Created by Lhkh on 2018/6/20.
//  Copyright © 2018年 Lhkh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+JSFrame.h"

@class ItemListImageModel;

@protocol LhkhImageSlideScrollViewDelegate<NSObject>
- (void)LhkhImageSlideScrollViewDelegateWithHeight:(CGFloat)height;
@end


@interface LhkhImageSlideScrollView : UIScrollView
- (void)slidingViewWithMMutableArray:(NSMutableArray <ItemListImageModel *> *)imageArray;
@property (weak, nonatomic)id<LhkhImageSlideScrollViewDelegate>imageslidDelegate;

@end
