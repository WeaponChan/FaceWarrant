//
//  ClassroomErrorView.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/12.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (int, ALYPVErrorType) {
    ALYPVErrorTypeUnknown = 0,
    ALYPVErrorTypeRetry,
    ALYPVErrorTypeReplay,
    ALYPVErrorTypePause,
};

@protocol ClassroomErrorViewDelegate <NSObject>

/*
 * 功能 ：错误状态提示
 * 参数 ： type 错误类型
 */
- (void)onErrorViewClickedWithType:(ALYPVErrorType)type;

@end

@interface ClassroomErrorView : UIView

@property (nonatomic, weak  ) id<ClassroomErrorViewDelegate> delegate;
@property (nonatomic, copy  ) NSString *message;                        //错误信息内容
@property (nonatomic, assign)ALYPVErrorType type;         //错误类型

/*
 * 功能 ：展示错误页面偏移量
 * 参数 ：parent 插入的界面
 */
- (void)showWithParentView:(UIView *)parent;

/*
 * 功能 ：是否展示界面
 */
- (BOOL)isShowing;

/*
 * 功能 ：是否删除界面
 */
- (void)dismiss;

@end
