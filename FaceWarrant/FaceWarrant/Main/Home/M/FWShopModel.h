//
//  FWShopModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/6.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWShopModel : NSObject
/*{
    storeAddress : 江苏省苏州工业园区圆融时代广场苏州大道广运国际金融中心1楼,
    longitude : 120.71479,
    distance : 784.32,
    storeType : 1,
    latitude : 31.322248,
    storeId : 4199,
    storeName : Ferrari 法拉利,
    storeMobile : 400-815-0011,8757
}*/

@property (copy, nonatomic)NSString *storeAddress;
@property (copy, nonatomic)NSString *longitude;
@property (copy, nonatomic)NSString *distance;
@property (copy, nonatomic)NSString *storeType;
@property (copy, nonatomic)NSString *storeId;
@property (copy, nonatomic)NSString *storeName;
@property (copy, nonatomic)NSString *storeMobile;
@property (copy, nonatomic)NSString *latitude;
@property (copy, nonatomic)NSString *storePromotion;
@property (copy, nonatomic)NSString *storePicture;
@property (copy, nonatomic)NSString *navigationCount;
@property (copy, nonatomic)NSString *phoneCount;

@end
