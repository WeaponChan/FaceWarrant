//
//  FWFacelibrarySearchModel.h
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFacelibrarySearchModel : NSObject
@property(strong, nonatomic) NSArray *groupsList;
@property(strong, nonatomic) NSArray *brandList;
@end


//userId : 2495,
//groupsId : 8221,
//faceNum : 1,
//groupsName : 旅游,
//groupsType : 3,
//createTime : 2018-09-14 11:36:45,
//isSelected : 0
@interface FWFacelibrarySearchGroupsListModel : NSObject
@property(copy, nonatomic) NSString *userId;
@property(copy, nonatomic) NSString *groupsId;
@property(copy, nonatomic) NSString *faceNum;
@property(copy, nonatomic) NSString *groupsName;
@property(copy, nonatomic) NSString *groupsType;
@property(copy, nonatomic) NSString *createTime;
@property(copy, nonatomic) NSString *isSelected;
@end

//brandId : 47,
//sortIdentifier : G,
//releaseCount : 2,
//brandName : GREE 格力
@interface FWFacelibrarySearchBrandListModel : NSObject
@property(copy, nonatomic) NSString *brandId;
@property(copy, nonatomic) NSString *sortIdentifier;
@property(copy, nonatomic) NSString *releaseCount;
@property(copy, nonatomic) NSString *brandName;
@end
