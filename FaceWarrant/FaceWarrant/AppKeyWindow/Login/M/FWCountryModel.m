//
//  FWCountryModel.m
//  FaceWarrant
//
//  Created by FW on 2018/8/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCountryModel.h"

@implementation FWCountryModel
+ (NSDictionary *)objectCountryListClassInDictionary{
    return @{@"countryList":[FWCountryListModel class]};
}
@end

@implementation FWCountryListModel

+(NSDictionary*)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
@end
