//
//  FWFaceLibraryModel.m
//  FaceWarrant
//
//  Created by FW on 2018/8/16.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceLibraryModel.h"

@implementation FWFaceLibraryModel

+(NSDictionary*)replacedKeyFromPropertyName
{
    return @{@"hasnewReleaseGoodsCount":@"newReleaseGoodsCount"};
}

+(NSDictionary*)objectReplaceWithReleaseGoodsListInDictionary
{
    return @{@"releaseGoodsList":[FaceLibReleaseGoodsListModel class]};
}
@end

@implementation FaceLibReleaseGoodsListModel

@end
