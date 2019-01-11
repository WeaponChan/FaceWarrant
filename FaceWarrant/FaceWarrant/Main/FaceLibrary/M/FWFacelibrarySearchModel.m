//
//  FWFacelibrarySearchModel.m
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFacelibrarySearchModel.h"

@implementation FWFacelibrarySearchModel
+(NSDictionary*)objectReplaceWithGroupsListInDictionary
{
    return @{@"groupsList":[FWFacelibrarySearchGroupsListModel class]};
}

+(NSDictionary*)objectReplaceWithReleaseBrandListInDictionary
{
    return @{@"brandList":[FWFacelibrarySearchBrandListModel class]};
}

@end


@implementation FWFacelibrarySearchGroupsListModel

@end


@implementation FWFacelibrarySearchBrandListModel

@end
