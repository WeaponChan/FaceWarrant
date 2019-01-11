//
//  FWBrandModel.h
//  FaceWarrant
//
//  Created by FW on 2018/9/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
//disabled : 0,
//sortIdentifier : A,
//supplierId : 0,
//brandId : 299,
//brandName : Acne Studios 艾克妮
@interface FWBrandModel : NSObject
@property (copy, nonatomic)NSString *disabled;
@property (copy, nonatomic)NSString *sortIdentifier;
@property (copy, nonatomic)NSString *supplierId;
@property (copy, nonatomic)NSString *brandId;
@property (copy, nonatomic)NSString *releaseCount;
@property (copy, nonatomic)NSString *brandName;
@end
