//
//  ClassroomGestureModel.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(int, ALYPVOrientation) {
    ALYPVOrientationUnknow = 0,
    ALYPVOrientationHorizontal,
    ALYPVOrientationVertical
};
@class ClassroomGestureModel;
@protocol ClassroomGestureModelDelegate <NSObject>
@required
//单击屏幕
- (void)onSingleClicked;

//双击屏幕
- (void)onDoubleClicked;

//手势水平移动偏移量
- (void)horizontalOrientationMoveOffset:(float)moveOffset;

@optional
//手势在view左侧区域，上下移动时 对亮度的设置
- (void)ClassroomGestureModel:(ClassroomGestureModel*)aliyunGestureModel brightnessDirection:(UISwipeGestureRecognizerDirection)direction;

//手势在view左侧区域，上下移动时 对音量的设置
- (void)ClassroomGestureModel:(ClassroomGestureModel*)aliyunGestureModel volumeDirection:(UISwipeGestureRecognizerDirection)direction;

/*
 * 功能：手势移动方向
 * 参数 ：ALYPVGestureModel 对象自己
 state 手势当前状态（开始、移动、结束）
 moveOrientation 手势移动方向
 
 */
- (void)ClassroomGestureModel:(ClassroomGestureModel*)aliyunGestureModel state:(UIGestureRecognizerState)state moveOrientation:(ALYPVOrientation)moveOrientation;

@end
@interface ClassroomGestureModel : NSObject

@property (nonatomic, weak) id<ClassroomGestureModelDelegate>delegate;
/*
 * 功能 ：手势添加到特定的view中
 */
- (void)setView:(id)view;

/*
 * 功能 ：设置手势禁用功能
 */
- (void)setEnableGesture:(BOOL)enableGesture;
@end
