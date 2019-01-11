//
//  FWFaceValueNoteModel.h
//  FaceWarrant
//
//  Created by FW on 2018/8/22.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWFaceValueNoteModel : NSObject

@property (strong, nonatomic)NSArray *accountExpendList;
@property (copy, nonatomic)NSString *dateYearMonth;

@end

@interface FWAccountExpendListModel : NSObject


//withdrawFee : 2, 1
//beforeFee : 0,1
//status : 2,1
//withdrawalsTime : 08-21 18:13,1
//realName : hans,1
//afterFee : 20005.2,1
//bankId : 3004,2
//bankName : 建设银行,2
//bankAccountNumber : 32128419941007233,1
//expendType : 01

//withdrawFee : 2,
//beforeFee : 0,
//status : 1,
//withdrawalsTime : 08-21 16:22,
//realName : 沙箱环境,
//afterFee : 20007.2,
//bankAccountNumber : egxlqj1995@sandbox.com,
//expendType : 1

@property (copy, nonatomic)NSString *withdrawFee;
@property (copy, nonatomic)NSString *beforeFee;
@property (copy, nonatomic)NSString *status;
@property (copy, nonatomic)NSString *withdrawalsTime;
@property (copy, nonatomic)NSString *realName;
@property (copy, nonatomic)NSString *afterFee;
@property (copy, nonatomic)NSString *bankId;
@property (copy, nonatomic)NSString *bankName;
@property (copy, nonatomic)NSString *bankAccountNumber;
@property (copy, nonatomic)NSString *expendType;
@property (copy, nonatomic)NSString *accountExpend;
@end
