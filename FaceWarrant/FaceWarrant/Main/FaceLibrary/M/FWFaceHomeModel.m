//
//  FWFaceHomeModel.m
//  FaceWarrant
//
//  Created by FW on 2018/8/16.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceHomeModel.h"

@implementation FWFaceHomeModel
+(NSDictionary*)objectReplaceWithbrandListInDictionary
{
    return @{@"brandList":[FWFaceBrandListModel class]};
}
@end


@implementation FWFaceBrandListModel

@end
