//
//  ClassroomQualityListView.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClassroomQualityListViewDelegate <NSObject>
/*
 * 功能 ：清晰度列表选择
 */
- (void)qualityListViewOnItemClick:(int)index;
@end
@interface ClassroomQualityListView : UIView
@property (nonatomic, weak  ) id<ClassroomQualityListViewDelegate> delegate;
@property (nonatomic, copy  ) NSArray *allSupportQualities;             //清晰度列表信息
/*
 * 功能 ：计算清晰度列表所需高度
 */
- (float)estimatedHeight;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString*)videoDefinition;

@end
