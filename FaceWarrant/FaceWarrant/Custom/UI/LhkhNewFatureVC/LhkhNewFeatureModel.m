//
//  LhkhNewFeatureModel.m
//  NWMJ_B
//
//  Created by LHKH on 2018/4/25.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "LhkhNewFeatureModel.h"

@implementation LhkhNewFeatureModel

/*
 *  初始化
 */
+(instancetype)model:(UIImage *)image{
    
    LhkhNewFeatureModel *model = [[LhkhNewFeatureModel alloc] init];
    
    model.image = image;
    
    return model;
}


@end
