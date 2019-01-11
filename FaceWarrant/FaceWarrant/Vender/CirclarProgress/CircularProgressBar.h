//
//  CircularProgressBar.h
//  CircularProgressBar
//
//  Created by du on 10/8/15.
//  Copyright © 2015 du. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CircularProgressDelegate

- (void)CircularProgressEnd;
- (void)CircularProgress:(NSString*)time;
@end


@interface CircularProgressBar : UIView
{
    CGFloat startAngle;
    CGFloat endAngle;
    int     totalTime;
    
    UIFont *textFont;
    UIColor *textColor;
    NSMutableParagraphStyle *textStyle;
    
    NSTimer *m_timer;
    bool b_timerRunning;
}

@property(nonatomic, assign) id<CircularProgressDelegate> delegate;
@property(nonatomic)CGFloat time_left;

- (id)initWithFrame:(CGRect)frame type:(NSString *)type;

- (void)setTotalSecondTime:(CGFloat)time;
- (void)setTotalMinuteTime:(CGFloat)time;

- (void)startTimer;
- (void)stopTimer;
- (void)pauseTimer;

@end
