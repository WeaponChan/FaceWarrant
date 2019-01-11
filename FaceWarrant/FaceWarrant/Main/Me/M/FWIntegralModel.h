//
//  FWIntegralModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/21.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWIntegralModel : NSObject

@property (copy, nonatomic)NSString *remainderPoints;
@property (copy, nonatomic)NSString *pointsPercent;
@property (copy, nonatomic)NSString *pointsBase;
@property (copy, nonatomic)NSString *pointsRegister;
@property (strong, nonatomic)NSArray *pointsDetailList;
@end


@interface FWPointsDetailListModel : NSObject

@property (copy, nonatomic)NSString *points;
@property (copy, nonatomic)NSString *operateType;
@property (copy, nonatomic)NSString *useType;
@property (copy, nonatomic)NSString *afterPoints;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *beforePoints;
@end
