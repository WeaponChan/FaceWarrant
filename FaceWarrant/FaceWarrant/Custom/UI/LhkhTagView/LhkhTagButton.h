//
//  LhkhTagButton.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LhkhTag;
@interface LhkhTagButton : UIButton
+ (nonnull instancetype)buttonWithTag: (nonnull LhkhTag *)tag;
@end
