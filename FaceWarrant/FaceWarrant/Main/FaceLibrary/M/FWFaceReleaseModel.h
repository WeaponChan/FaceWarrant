//
//  FWFaceReleaseModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFaceReleaseModel : NSObject

@property (copy, nonatomic)NSString *Height;
@property (copy, nonatomic)NSString *isNew;
@property (copy, nonatomic)NSString *goodsName;
@property (copy, nonatomic)NSString *modelUrl;
@property (copy, nonatomic)NSString *videoUrl;
@property (copy, nonatomic)NSString *releaseGoodsId;
@property (copy, nonatomic)NSString *width;
@property (copy, nonatomic)NSString *modelType;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *favoriteCount;
@property (copy, nonatomic)NSString *buyNo;
@property (assign, nonatomic)BOOL isSelected;
@end
