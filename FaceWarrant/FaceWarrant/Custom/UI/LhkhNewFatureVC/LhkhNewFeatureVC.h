//
//  LhkhNewFeatureVC.h
//  NWMJ_B
//
//  Created by LHKH on 2018/4/25.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LhkhNewFeatureModel.h"


@interface LhkhNewFeatureVC : UIViewController

@property (nonatomic,strong) NSArray *images;



/*
 *  初始化
 */
+(instancetype)newFeatureVCWithModels:(NSArray *)models enterBlock:(void(^)(void))enterBlock;



/*
 *  是否应该显示版本新特性界面
 */
+(BOOL)canShowNewFeature;




@end
