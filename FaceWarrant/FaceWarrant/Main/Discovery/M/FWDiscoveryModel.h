//
//  FWDiscoveryModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWDiscoveryModel : NSObject
/*favoriteCount : 0,
faceId : 1285,
faceName : 马云,
releaseGoodsList : [
                    {
                        userId : 0,
                        modelUrl : http://image.facewarrant.com.cn/WarrantImage/11810000061420180402092955.jpg,
                        goodsId : 0,
                        releaseGoodsId : 6021,
                        buyNo : 0
                    }*/

@property(copy, nonatomic)NSString *favoriteCount;
@property(copy, nonatomic)NSString *faceId;
@property(copy, nonatomic)NSString *faceName;
@property(strong, nonatomic)NSArray *releaseGoodsList;
@end


@interface ReleaseGoodsListModel : NSObject

@property(copy, nonatomic)NSString *userId;
@property(copy, nonatomic)NSString *modelUrl;
@property(copy, nonatomic)NSString *goodsId;
@property(strong, nonatomic)NSString *releaseGoodsId;
@property(strong, nonatomic)NSString *buyNo;

@end
