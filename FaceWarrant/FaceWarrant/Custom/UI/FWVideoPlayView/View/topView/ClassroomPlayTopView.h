//
//  ClassroomPlayTopView.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassroomPlayTopView;
@protocol ClassroomPlayTopViewDelegate <NSObject>
/*
 * 功能 ： 点击返回按钮
 * 参数 ： topView 对象本身
 */
- (void)onBackViewClickWithClassroomPlayTopView:(ClassroomPlayTopView*)topView;

/*
 * 功能 ： 点击展示倍速播放界面按钮
 * 参数 ： 对象本身
 */
- (void)onMoreViewClickedWithClassroomPlayTopView:(ClassroomPlayTopView*)topView;


@end
@interface ClassroomPlayTopView : UIView

@property (nonatomic, weak  ) id<ClassroomPlayTopViewDelegate>delegate;
@property (nonatomic, copy  ) NSString *topTitle;                   //标题

@end
