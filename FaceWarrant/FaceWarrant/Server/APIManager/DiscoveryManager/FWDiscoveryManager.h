//
//  FWDiscoveryManager.h
//  FaceWarrant
//
//  Created by FW on 2018/8/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWDiscoveryModel.h"
#import "FWDiscoveryFaceModel.h"
@interface FWDiscoveryManager : NSObject

/**
 获取发现栏目 新品

 @param parameters 传参
 @param result 模型
 */
+ (void)loadDiscoveryFaceWithParameters:(id)parameters result:(void(^)(NSArray *dataArr,NSString *type))result;
@end
