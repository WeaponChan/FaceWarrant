//
//  ClassroomPopView.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/12.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassroomLoadingView.h"
#import "ClassroomErrorView.h"
typedef NS_ENUM(int, ALYPVPlayerPopCode) {
    // 未知错误
    ALYPVPlayerPopCodeUnKnown = 0,
    // 当用户播放完成后提示用户可以重新播放。    再次观看，请点击重新播放
    ALYPVPlayerPopCodePlayFinish = 1,
    // 用户主动取消播放
    ALYPVPlayerPopCodeStop = 2,
    // 服务器返回错误情况
    ALYPVPlayerPopCodeServerError= 3,
    // 播放中的情况
    // 当网络超时进行提醒（文案统一可以定义），用户点击可以进行重播。      当前网络不佳，请稍后点击重新播放
    ALYPVPlayerPopCodeNetworkTimeOutError = 4,
    
    // 断网时进行断网提醒，点击可以重播（按记录已经请求成功的url进行请求播放） 无网络连接，检查网络后点击重新播放
    ALYPVPlayerPopCodeUnreachableNetwork = 5,
    
    // 当视频加载出错时进行提醒，点击可重新加载。   视频加载出错，请点击重新播放
    ALYPVPlayerPopCodeLoadDataError = 6,
    
    // 当用户使用移动网络播放时，首次不进行自动播放，给予提醒当前的网络状态，用户可手动使用移动网络进行播放。顶部提示条仅显示4秒自动消失。当用户从wifi切到移动网络时，暂定当前播放给予用户提示当前的网络，用户可以点击播放后继续当前播放。
    ALYPVPlayerPopCodeUseMobileNetwork,
};
@class ClassroomPopView;
@protocol ClassroomPopViewDelegate <NSObject>

/*
 * 功能 ：点击返回时操作
 * 参数 ：popLayer 对象本身
 */
- (void)onBackClickedWithClassroomPopView:(ClassroomPopView *)popLayer ;

/*
 * 功能 ：提示错误信息时，当前按钮状态
 * 参数 ：type 错误类型
 */
- (void)showPopViewWithType:(ALYPVErrorType)type WithPopCode:(ALYPVPlayerPopCode)code;

@end
@interface ClassroomPopView : UIView
@property (nonatomic, weak) id<ClassroomPopViewDelegate>delegate;
/*
 * 功能 ：根据不同code，展示弹起的消息界面
 * 参数 ： code ： 事件
 popMsg ：自定义消息
 */
- (void)showPopViewWithCode:(ALYPVPlayerPopCode)code popMsg:(NSString *)popMsg;
@end
