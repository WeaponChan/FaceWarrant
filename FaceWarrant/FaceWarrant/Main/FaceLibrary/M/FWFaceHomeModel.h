//
//  FWFaceHomeModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/16.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFaceHomeModel : NSObject
/*"brandList": [
              {
    "brandId": 299,
    "brandName": "Acne Studios 艾克妮",
    "sortIdentifier": "A",
    "brandSynopsis": null,
    "supplierId": 0,
    "creator": null,
    "createTime": null,
    "updater": null,
    "updateTime": null,
    "suppliers": null,
    "brandUrl": null,
    "iddCodes": null,
    "disabled": false
},
{
    "brandId": 822,
    "brandName": "ASICS 亚瑟士",
    "sortIdentifier": "A",
    "brandSynopsis": null,
    "supplierId": 0,
    "creator": null,
    "createTime": null,
    "updater": null,
    "updateTime": null,
    "suppliers": null,
    "brandUrl": null,
    "iddCodes": null,
    "disabled": false
},
{
    "brandId": 481,
    "brandName": "Paul Smith 保罗·史密斯",
    "sortIdentifier": "P",
    "brandSynopsis": null,
    "supplierId": 0,
    "creator": null,
    "createTime": null,
    "updater": null,
    "updateTime": null,
    "suppliers": null,
    "brandUrl": null,
    "iddCodes": null,
    "disabled": false
}
],
"isAttention": 1,
"isBigFace": 1,
"faceId": 1263,
"attentionCount": 297,
"favouriteCount": 3,
"name": "Adam",
"headUrl": "http://image.facewarrant.com.cn/HeadImage/31363276689520180416131157.jpg",
"standing": "CEO",
"fansCount": 134
}*/

@property(copy, nonatomic)NSString *isAttention;
@property(copy, nonatomic)NSString *isBigFace;
@property(copy, nonatomic)NSString *faceId;
@property(copy, nonatomic)NSString *attentionCount;
@property(copy, nonatomic)NSString *favouriteCount;
@property(copy, nonatomic)NSString *faceName;
@property(copy, nonatomic)NSString *headUrl;
@property(copy, nonatomic)NSString *backgroundImg;
@property(copy, nonatomic)NSString *standing;
@property(copy, nonatomic)NSString *fansCount;
@property(copy, nonatomic)NSString *releaseGoodsCount;
@property(strong, nonatomic)NSArray *brandList;

@end

@interface FWFaceBrandListModel : NSObject
@property(copy, nonatomic)NSString *brandId;
@property(copy, nonatomic)NSString *brandName;
@property(copy, nonatomic)NSString *sortIdentifier;
@property(copy, nonatomic)NSString *brandSynopsis;
@property(copy, nonatomic)NSString *supplierId;
@property(copy, nonatomic)NSString *creator;
@property(copy, nonatomic)NSString *createTime;
@property(copy, nonatomic)NSString *updater;
@property(copy, nonatomic)NSString *updateTime;
@property(copy, nonatomic)NSString *suppliers;
@property(copy, nonatomic)NSString *brandUrl;
@property(copy, nonatomic)NSString *iddCodes;
@property(copy, nonatomic)NSString *disabled;

@end
