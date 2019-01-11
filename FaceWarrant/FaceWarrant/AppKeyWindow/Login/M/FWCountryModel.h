//
//  FWCountryModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWCountryModel : NSObject
//{
//    first : 0,
//    countryList : [
//                   {
//                       sum : 0,
//                       id : 94001,
//                       code : 0,
//                       value : 86,
//                       name : 中国大陆,
//                       supId : 94
//                   }

@property (copy, nonatomic)NSString *first;
@property (strong, nonatomic)NSArray *countryList;
@end


@interface FWCountryListModel : NSObject


@property (copy, nonatomic)NSString *sum;
@property (copy, nonatomic)NSString *ID;
@property (copy, nonatomic)NSString *code;
@property (copy, nonatomic)NSString *value;
@property (copy, nonatomic)NSString *name;
@property (copy, nonatomic)NSString *supId;
@end

