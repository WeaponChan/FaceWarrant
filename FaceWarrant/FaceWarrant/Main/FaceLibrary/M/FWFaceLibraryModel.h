//
//  FWFaceLibraryModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/16.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFaceLibraryModel : NSObject
/*{
    "faceId": 1283,
    "faceName": "凯特王妃",
    "releaseGoodsCount": 1,
    "releaseGoodsList": [
                         {
                             "releaseGoodsId": 5950,
                             "userId": 0,
                             "goodsTypeName": null,
                             "goodsTypeId": 0,
                             "styleFormat": null,
                             "buyNo": 0,
                             "useDetail": null,
                             "modelUrl": "http://image.facewarrant.com.cn/WarrantImage/11810000000220180521164948.jpg",
                             "modelType": 0,
                             "createTime": null,
                             "creator": null,
                             "updater": null,
                             "updateTime": null
                         }
                         ],
    "headUrl": "http://image.facewarrant.com.cn/android/head/file/20170510221127image.jpg",
    "fansCount": 220
}*/

@property(copy, nonatomic)NSString *faceId;
@property(copy, nonatomic)NSString *faceName;
@property(copy, nonatomic)NSString *releaseGoodsCount;
@property(copy, nonatomic)NSString *hasnewReleaseGoodsCount;
@property(copy, nonatomic)NSString *headUrl;
@property(copy, nonatomic)NSString *userIndex;
@property(copy, nonatomic)NSString *fansCount;
@property(strong, nonatomic)NSArray *releaseGoodsList;
@end

@interface FaceLibReleaseGoodsListModel : NSObject

@property(copy, nonatomic)NSString *releaseGoodsId;
@property(copy, nonatomic)NSString *userId;
@property(copy, nonatomic)NSString *goodsTypeName;
@property(copy, nonatomic)NSString *goodsTypeId;
@property(copy, nonatomic)NSString *styleFormat;
@property(copy, nonatomic)NSString *buyNo;
@property(copy, nonatomic)NSString *useDetail;
@property(copy, nonatomic)NSString *modelUrl;
@property(copy, nonatomic)NSString *modelType;
@property(copy, nonatomic)NSString *createTime;
@property(copy, nonatomic)NSString *creator;
@property(copy, nonatomic)NSString *updater;
@property(copy, nonatomic)NSString *updateTime;

@end
