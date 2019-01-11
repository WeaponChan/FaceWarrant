//
//  FWCommentListVC.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWWarrantDetailModel.h"
@interface FWCommentListVC : FWBaseViewController
@property(assign, nonatomic)NSInteger indexTag;
@property(copy, nonatomic)NSString *releaseGoodsId;
@property(copy, nonatomic)NSString *commentType; //1表示评论碑它  2表示评论某条评论  3表示回复某个人的评论
@property(copy, nonatomic)NSString *fromWarrant;//从碑它详情跳转来的
@property(strong,nonatomic)FWWarrantDetailModel *dModel;
@property(strong,nonatomic)CommendReplyModel *cModel;
@end
