//
//  FWRecommendModel.h
//  FaceWarrant
//
//  Created by FW on 2018/9/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWRecommendModel : NSObject
@property (copy, nonatomic)NSString *headUrl;
@property (copy, nonatomic)NSString *faceId;
@property (copy, nonatomic)NSString *faceName;
@property (copy, nonatomic)NSString *sortIdentifier;
@property (copy, nonatomic)NSString *standing;
@property (assign, nonatomic)BOOL isAttened;
@end
