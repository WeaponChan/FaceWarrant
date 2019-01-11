//
//  FWFaceLibraryClassifyModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/15.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFaceLibraryClassifyModel : NSObject
//{
//    "groupsId": 9,
//    "userId": 1263,
//    "groupsType": 1,
//    "groupsName": "大Face",
//    "createTime": "2018-01-08 10:32:28",
//    "faceNum": 1,
//    "isSelected": 0
//},

@property (copy, nonatomic)NSString *groupsId;
@property (copy, nonatomic)NSString *userId;
@property (copy, nonatomic)NSString *groupsType;
@property (copy, nonatomic)NSString *groupsName;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *faceNum;
@property (copy, nonatomic)NSString *isSelected;
@end
