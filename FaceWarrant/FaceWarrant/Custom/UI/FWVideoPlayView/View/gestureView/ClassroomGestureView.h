//
//  ClassroomGestureView.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassroomGestureView;
@protocol ClassroomGestureViewDelegate <NSObject>

//单击屏幕
- (void)onSingleClickedWithClassroomGestureView:(ClassroomGestureView *)gestureView;

//双击屏幕
- (void)onDoubleClickedWithClassroomGestureView:(ClassroomGestureView *)gestureView;

//手势水平移动偏移量
- (void)horizontalOrientationMoveOffset:(float)moveOffset;

@end

@interface ClassroomGestureView : UIView
@property (nonatomic, weak) id<ClassroomGestureViewDelegate>delegate;

/*
 * 功能 ： 是否禁用手势（双击、滑动）
 */
- (void)setEnableGesture:(BOOL)enableGesture;

/*
 * 功能 ： 传递
 */
- (void)setSeekTime:(NSTimeInterval)time direction:(UISwipeGestureRecognizerDirection)direction;

@end
