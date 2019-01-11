//
//  FWWarrantExperienceCell.h
//  FaceWarrant
//
//  Created by LHKH on 2018/7/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FWWarrantExperienceCellDelegate <NSObject>
- (void)FWWarrantExperienceCellDelegateText:(NSString*)text;
- (void)FWWarrantExperienceCellDelegateMicCkick;
@end

@interface FWWarrantExperienceCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)cellConfigWithExperience:(NSString *)experience indexPath:(NSIndexPath*)indexPath;
@property (weak, nonatomic)id<FWWarrantExperienceCellDelegate>delegate;
@end
