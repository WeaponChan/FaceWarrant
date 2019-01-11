//
//  FWSearchCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FWSearchCellDelegate <NSObject>
- (void)FWSearchCellDelegateClearAction;
- (void)FWSearchCellDelegateItemClick:(NSString *)item;

@end
@interface FWSearchCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (CGFloat)configCellHeightWithData:(NSMutableArray*)data indexPath:(NSIndexPath*)indexPath  type:(NSString*)type;
- (void)configCellWithData:(NSMutableArray*)data indexPath:(NSIndexPath*)indexPath type:(NSString*)type;
@property (weak, nonatomic)id<FWSearchCellDelegate>delegate;
@end
