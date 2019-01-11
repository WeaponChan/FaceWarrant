//
//  FWFacelibrarySearchFaceModel.h
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
//headUrl : http://image.facewarrant.com.cn/HeadImage/11810000000020180419101238.jpg,
//faceId : 2237,
//faceName : 刘玲 EVA,
//standing : 深圳市益田假日广场有限公司 总经理,
//fansCount : 152
@interface FWFacelibrarySearchFaceModel : NSObject
@property(copy, nonatomic) NSString *headUrl;
@property(copy, nonatomic) NSString *faceId;
@property(copy, nonatomic) NSString *faceName;
@property(copy, nonatomic) NSString *standing;
@property(copy, nonatomic) NSString *fansCount;
@property(copy, nonatomic) NSString *isAttention;
@end
