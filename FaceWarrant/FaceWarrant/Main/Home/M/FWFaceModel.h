//
//  FWFaceModel.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/26.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFaceModel : NSObject

@property (copy, nonatomic)NSString *nickName;
@property (copy, nonatomic)NSString *trueName;
@property (copy, nonatomic)NSString *userId;
@property (copy, nonatomic)NSString *portraitUrl;
@property (copy, nonatomic)NSString *cnt;
@property (copy, nonatomic)NSString *powerweight;
@property (copy, nonatomic)NSString *isAttentioned;
@property (copy, nonatomic)NSString *standing;
@property (copy, nonatomic)NSString *memberClass;
@property (copy, nonatomic)NSString *hasNew;
@property (copy, nonatomic)NSString *hasNewReleaseGoodsCount;

@property (copy, nonatomic)NSString *type;
@property (assign, nonatomic)BOOL isAttened;
@end
