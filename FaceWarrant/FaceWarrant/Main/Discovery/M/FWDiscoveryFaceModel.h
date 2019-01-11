//
//  FWDiscoveryFaceModel.h
//  FaceWarrant
//
//  Created by FW on 2018/9/7.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
//powerweight : 0,
//isAttentioned : 0,
//hasNewReleaseGoodsCount : 0,
//standing : “YUN芸”帽品牌创始人,
//width : 389,
//portraitUrl : http://image.facewarrant.com.cn/HeadImage/11816899309620180416110951.jpg,
//userId : 2219,
//cnt : 785,
//hasNew : 0,
//height : 390,
//trueName : 孙子芸
@interface FWDiscoveryFaceModel : NSObject
@property (copy, nonatomic)NSString *powerweight;
@property (copy, nonatomic)NSString *isAttentioned;
@property (copy, nonatomic)NSString *hasNewReleaseGoodsCount;
@property (copy, nonatomic)NSString *standing;
@property (copy, nonatomic)NSString *width;
@property (copy, nonatomic)NSString *portraitUrl;
@property (copy, nonatomic)NSString *userId;
@property (copy, nonatomic)NSString *cnt;
@property (copy, nonatomic)NSString *hasNew;
@property (copy, nonatomic)NSString *height;
@property (copy, nonatomic)NSString *trueName;
@property (assign, nonatomic)BOOL isAttened;
@end
