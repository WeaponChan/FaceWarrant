//
//  FWContactModel.h
//  FaceWarrant
//
//  Created by FW on 2018/9/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FWContactModel : NSObject
@property (copy, nonatomic)NSString *faceId;
@property (copy, nonatomic)NSString *faceName;
@property (copy, nonatomic)NSString *contactName;
@property (copy, nonatomic)NSString *headUrl;
@property (copy, nonatomic)NSString *mobile;
@property (copy, nonatomic)NSString *countryCode;
@property (copy, nonatomic)NSString *formatMobile;
@property (copy, nonatomic)NSString *standing;
@property (copy, nonatomic)NSString *sortIdentifier;
@property (copy, nonatomic)NSString *isAttention;
@property (copy, nonatomic)NSString *isInGroup;
@property (copy, nonatomic)NSString *isRegistered;
@property (copy, nonatomic)NSString *releaseGoodsCount;
@property (assign, nonatomic)BOOL isInvited;
@property (assign, nonatomic)BOOL isAdd;
@property (strong, nonatomic)NSIndexPath *indexPath;
@end
