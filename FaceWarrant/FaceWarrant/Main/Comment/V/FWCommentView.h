//
//  FWCommentView.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWWarrantDetailModel,FWCommendReplyModel,FWReplyModel;
@protocol FWCommentViewDelegate <NSObject>
- (void)FWCommentViewDelegateSubCellClickWithModel:(FWReplyModel*)rmodel indexPath:(NSIndexPath *)indexPath;
- (void)FWCommentViewDelegateSubCellDeleteClickWithModel:(FWReplyModel*)rmodel indexPath:(NSIndexPath *)indexPath;
@end
@interface FWCommentView : UIView
@property (weak, nonatomic)id<FWCommentViewDelegate>delegate;
- (void)configViewWithModel:(FWWarrantDetailModel*)dmodel model:(FWCommendReplyModel*)model moreReplyArr:(NSArray*)moreReplyArr;
@end
