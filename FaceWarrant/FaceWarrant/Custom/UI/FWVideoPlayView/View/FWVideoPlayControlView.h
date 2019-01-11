//
//  FWVideoPlayControlView.h
//  FaceWarrant
//
//  Created by FW on 2018/10/23.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassroomPlayTopView.h"
#import "ClassroomPlayBottomView.h"
#import "ClassroomGestureView.h"

@class FWVideoPlayControlView;
@protocol FWVideoPlayControlViewDelegate <NSObject>
/*
 * 功能 ： 点击返回按钮
 * 参数 ： controlView 对象本身
 */
- (void)onBackViewClickWithClassroomPlayControView:(FWVideoPlayControlView*)controlView;

/*
 * 功能 ： 展示更多界面
 * 参数 ： controlView 对象本身
 */
- (void)onMoreViewClickedWithClassroomPlayControView:(FWVideoPlayControlView*)controlView;

/*
 * 功能 ： 播放按钮
 * 参数 ： controlView 对象本身
 */
- (void)onClickedPlayButtonWithClassroomPlayControView:(FWVideoPlayControlView*)controlView;

/*
 * 功能 ： 全屏
 * 参数 ： controlView 对象本身
 */
- (void)onClickedfullScreenButtonWithClassroomPlayControView:(FWVideoPlayControlView*)controlView;

/*
 * 功能 ： 锁屏
 * 参数 ： controlView 对象本身
 */
- (void)onLockButtonClickedWithClassroomPlayControView:(FWVideoPlayControlView*)controlView;
/*
 * 功能 ： 拖动进度条
 * 参数 ： controlView 对象本身
 progressValue slide滑动长度
 event 手势事件，点击-移动-离开
 */
- (void)ClassroomPlayControView:(FWVideoPlayControlView*)controlView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event;

/*
 * 功能 ： 清晰度切换
 * 参数 ： index 选择的清晰度
 */
- (void)ClassroomPlayControView:(FWVideoPlayControlView*)controlView qualityListViewOnItemClick:(int)index;


@end

@interface FWVideoPlayControlView : UIView

@property (nonatomic, weak  ) id<FWVideoPlayControlViewDelegate>delegate;
@property (nonatomic, strong) AliyunVodPlayerVideo *videoInfo;      //播放数据
@property (nonatomic, assign) AliyunVodPlayerState state;           //播放器播放状态
@property (nonatomic, copy)   NSString *title;                      //设置标题
@property (nonatomic, assign) float loadTimeProgress;               //缓存进度
@property (nonatomic, assign) BOOL isProtrait;                      //竖屏判断
@property (nonatomic, strong) UIButton *lockButton;                 //锁屏按钮
@property (nonatomic, strong) UIButton *playButton;                 //播放按钮
@property (nonatomic, strong) ClassroomQualityListView *listView;   //清晰度列表view

@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval duration;

/*
 * 功能 ：更新播放器状态
 */
- (void)updateViewWithPlayerState:(AliyunVodPlayerState)state isScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;

/*
 * 功能 ：更新进度条
 */
- (void)updateProgressWithCurrentTime:(NSTimeInterval)currentTime durationTime : (NSTimeInterval)durationTime;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString*)videoDefinition;

/*
 * 功能 ：是否禁用手势（双击、滑动)
 */
- (void)setEnableGesture:(BOOL)enableGesture;

/*
 * 功能 ：隐藏topView、bottomView
 */
- (void)hiddenView;

/*
 * 功能 ：展示topView、bottomView
 */
- (void)showView;

/*
 * 功能 ：锁屏
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;

/*
 * 功能 ：取消锁屏
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;


- (void)setQualityButtonTitle:(NSString *)title;

@end
