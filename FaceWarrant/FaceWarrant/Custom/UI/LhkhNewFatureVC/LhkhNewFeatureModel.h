//
//  LhkhNewFeatureModel.h
//  NWMJ_B
//
//  Created by LHKH on 2018/4/25.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LhkhNewFeatureModel : NSObject

@property (nonatomic,strong) UIImage *image;


/*
 *  初始化
 */
+(instancetype)model:(UIImage *)image;

@end
