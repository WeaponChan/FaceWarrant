//
//  FWAttentionModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWAttentionModel : NSObject

//headUrl : http://image.facewarrant.com.cn/android/head/file/13906035675image.jpg,
//faceId : 1604,
//sortIdentifier : H,
//name : 洪本祝,
//standing : 福建省厦门市商务局  局长

@property(copy, nonatomic)NSString *headUrl;
@property(copy, nonatomic)NSString *faceId;
@property(copy, nonatomic)NSString *sortIdentifier;
@property(copy, nonatomic)NSString *faceName;
@property(copy, nonatomic)NSString *standing;
@property(assign, nonatomic)BOOL isAttened;
@property(assign, nonatomic)BOOL isSelect;
@property(strong, nonatomic)NSIndexPath *indexPath;
@end
