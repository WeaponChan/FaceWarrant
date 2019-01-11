//
//  ClassroomGifView.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/12.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassroomGifView : UIView
/*
 * 功能 ：设定gif动画图片
 */
- (void)setGifImageWithName:(NSString *)name;

/*
 * 功能 ：开始动画
 */
- (void)startAnimation;

/*
 * 功能 ：停止动画
 */
- (void)stopAnimation;
@end
