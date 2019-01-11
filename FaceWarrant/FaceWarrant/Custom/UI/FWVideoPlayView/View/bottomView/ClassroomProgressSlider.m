//
//  ClassroomProgressSlider.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomProgressSlider.h"

@interface ClassroomProgressSlider()

@end

@implementation ClassroomProgressSlider

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


#pragma mark - Layout SubViews




#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGRect t = [self trackRectForBounds: [self bounds]];
    float v = [self minimumValue] + ([[touches anyObject] locationInView: self].x - t.origin.x - 4.0) * (([self maximumValue]-[self minimumValue]) / (t.size.width - 8.0));
    
    if ([self.delegate respondsToSelector:@selector(ClassroomProgressSlider:clickedSlider:)] ) {
        [self.delegate ClassroomProgressSlider:self clickedSlider:v];
    }
    [super touchesBegan: touches withEvent: event];
}




#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods




#pragma mark - Setters




#pragma mark - Getters



@end
