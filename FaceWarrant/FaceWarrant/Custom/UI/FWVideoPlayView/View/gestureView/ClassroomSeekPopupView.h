//
//  ClassroomSeekPopupView.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassroomSeekPopupView : UIView
/*
 * 功能 ： 当前时间点的滑动方向，并展示
 * 参数 ： time：当前播放时间，秒
 direciton ： 滑动方向，左右
 */
- (void)setSeekTime:(NSTimeInterval)time direction :(UISwipeGestureRecognizerDirection)direciton;

/*
 * 功能 ： 展示view
 */
- (void)showWithParentView:(UIView *)parent;

/*
 * 功能 ： 1秒后移除 view
 */
- (void)dismiss;
@end
