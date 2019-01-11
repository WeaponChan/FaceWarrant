//
//  FWAiteFaceModel.h
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWAiteFaceModel : NSObject
@property (strong, nonatomic)NSDictionary *facesList;
@property (strong, nonatomic)NSArray *groupsList;
@end

@interface FWAiteFacesListModel : NSObject
@property (copy, nonatomic)NSString *headUrl;
@property (copy, nonatomic)NSString *faceId;
@property (copy, nonatomic)NSString *faceName;
@property (copy, nonatomic)NSString *sortIdentifier;
@property (copy, nonatomic)NSString *standing;
@property (strong, nonatomic)NSIndexPath *indexPath;
@property (copy, nonatomic)NSString *isSelected;

@property (assign, nonatomic)BOOL isSelect;
@end

@interface FWAiteGroupsListModel : NSObject
@property (copy, nonatomic)NSString *userId;
@property (copy, nonatomic)NSString *groupsId;
@property (copy, nonatomic)NSString *faceNum;
@property (copy, nonatomic)NSString *groupsName;
@property (copy, nonatomic)NSString *groupsType;
@property (copy, nonatomic)NSString *createTime;
@property (copy, nonatomic)NSString *isSelected;
@property (strong, nonatomic)NSIndexPath *indexPath;
@property (assign, nonatomic)BOOL isSelect;
@end
