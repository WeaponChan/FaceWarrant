//
//  FWMQReplyCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWMessageAModel;

@protocol FWMQReplyCellDelClickDelegate <NSObject>

- (void)FWMQReplyCellDelClickDelegate:(NSString*)answerId;

@end

@interface FWMQReplyCell : UITableViewCell
+ (CGFloat)cellHeight;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(FWMessageAModel*)model vctype:(NSString*)vctype;

@property (weak, nonatomic)id<FWMQReplyCellDelClickDelegate>delegate;
@end
