//
//  ClassroomProgressView.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassroomProgressSlider.h"

@class ClassroomProgressView;
@protocol ClassroomProgressViewDelegate <NSObject>

/*
 * 功能 ： 移动距离
 参数 ： dragProgressSliderValue slide滑动长度
 event 手势事件，点击-移动-离开
 */
- (void)ClassroomProgressView:(ClassroomProgressView *)progressView dragProgressSliderValue:(float)value event:(UIControlEvents)event;
@end
@interface ClassroomProgressView : UIView
@property (nonatomic, weak) id<ClassroomProgressViewDelegate>delegate;
@property (nonatomic, assign) float progress;                  //设置sliderValue
@property (nonatomic, assign) float loadTimeProgress;          //设置缓冲progress

/*
 * 功能 ：更新进度条
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime : (float)durationTime;
@end
