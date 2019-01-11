//
//  FWAddWarrantBottomView.h
//  FaceWarrant
//
//  Created by FW on 2018/9/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FWAddWarrantBottomViewActionTagBlock)(NSInteger tag);

@interface FWAddWarrantBottomView : UIView
@property (nonatomic, copy) FWAddWarrantBottomViewActionTagBlock tagBlock;
@end
