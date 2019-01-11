//
//  FWAiteFaceModel.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAiteFaceModel.h"

@implementation FWAiteFaceModel
+(NSDictionary*)objectReplaceWithFacesListInDictionary
{
    return @{@"facesList":[FWAiteFacesListModel class]};
}
+(NSDictionary*)objectReplaceWithGroupsListInDictionary
{
    return @{@"groupsList":[FWAiteGroupsListModel class]};
}
@end

@implementation FWAiteFacesListModel

@end

@implementation FWAiteGroupsListModel

@end
