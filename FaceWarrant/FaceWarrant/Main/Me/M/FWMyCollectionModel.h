//
//  FWMyCollectionModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWMyCollectionModel : NSObject
//faceId : 2160,
//collectStatus : 2,
//brandId : 158,
//goodsName : 长裙,
//goodsId : 3942,
//releaseGoodsId : 5258,
//modelUrl : http://image.facewarrant.com.cn/WarrantImage/11810000061220180402085807.jpg,
//brandName : Lanvin 朗雯,
//createTime : 07-25 14:10

@property (copy, nonatomic)NSString *faceId;
@property (copy, nonatomic)NSString *collectStatus;
@property (copy, nonatomic)NSString *brandId;
@property (copy, nonatomic)NSString *goodsName;
@property (copy, nonatomic)NSString *goodsId;
@property (copy, nonatomic)NSString *releaseGoodsId;
@property (copy, nonatomic)NSString *modelUrl;
@property (copy, nonatomic)NSString *brandName;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *buyNo;
@property (copy, nonatomic)NSString *favoriteCount;
@property (copy, nonatomic)NSString *width;
@property (copy, nonatomic)NSString *height;
@property (copy, nonatomic)NSString *modelType;
@property (assign, nonatomic)BOOL isSel;
@end
