//
//  FWWarrantSubCommentCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReplyModel;
@interface FWWarrantSubCommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;


/**
 渲染回复内容  使能点击用户的昵称跳转个人中心

 @param reply 回复的内容
 @param userC 评论作者的人 或者作者
 @param userR 回复评论者的人
 @param indexPath 当前的index
 */
//- (void)configCellWithReply:(NSString*)reply userC:(NSString*)userC userR:(NSString*)userR indexPath:(NSIndexPath*)indexPath;
- (void)configCellWithReply:(ReplyModel*)rmodel indexPath:(NSIndexPath*)indexPath;
@end
