//
//  ClassroomProgressSlider.h
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassroomProgressSlider;
@protocol ClassroomProgressSliderDelegate <NSObject>
- (void)ClassroomProgressSlider:(ClassroomProgressSlider *)slider clickedSlider:(float)sliderValue;
@end
@interface ClassroomProgressSlider : UISlider
@property (nonatomic, weak) id<ClassroomProgressSliderDelegate>delegate;
@end
