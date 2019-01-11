//
//  LhkhButton.m
//  LhkhBaseProjectDemo
//
//  Created by LHKH on 2017/3/13.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhButton.h"
@interface LhkhButton()

@end

@implementation LhkhButton

-(nonnull instancetype )initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:Color_Black forState:UIControlStateNormal];
        [self setTitleColor:Color_Theme_Pink forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}
@end
