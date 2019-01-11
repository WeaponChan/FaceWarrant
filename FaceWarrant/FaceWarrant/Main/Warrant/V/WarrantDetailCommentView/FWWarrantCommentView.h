//
//  FWWarrantCommentView.h
//  FaceWarrant
//
//  Created by FW on 2018/8/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommendReplyModel,FWWarrantDetailModel;
@interface FWWarrantCommentView : UIView
- (void)configViewWithModel:(CommendReplyModel*)model;
@property (strong, nonatomic)FWWarrantDetailModel *dModel;
@end
