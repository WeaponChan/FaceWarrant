//
//  UIView+CoreListLayout.m
//  NWMJ_B
//
//  Created by LHKH on 2018/4/25.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "UIView+LhkhLayout.h"

@implementation UIView (LhkhLayout)

-(void)autoLayoutFillSuperView {
    
    if(self.superview == nil) {return;}
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"v":self};
    
    NSArray *v_ver = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[v]-0-|" options:0 metrics:nil views:views];
    NSArray *v_hor = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[v]-0-|" options:0 metrics:nil views:views];
    [self.superview addConstraints:v_ver];[self.superview addConstraints:v_hor];
}

@end
