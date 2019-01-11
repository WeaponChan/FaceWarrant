//
//  FWQDetailVCell.h
//  FaceWarrant
//
//  Created by FW on 2018/9/26.
//  Copyright © 2018年 LHKH. All rights reserved.
//

typedef NS_ENUM(NSUInteger, LGVoicePlayState){
    LGVoicePlayStateNormal,/**< 未播放状态 */
    LGVoicePlayStateDownloading,/**< 正在下载中 */
    LGVoicePlayStatePlaying,/**< 正在播放 */
    LGVoicePlayStateCancel,/**< 播放被取消 */
};

#import <UIKit/UIKit.h>
@class FWQAndADetailModel,AnswerInfoListModel,FWQDetailVCell;

@protocol FWQDetailVCellDelegate <NSObject>

- (void)FWQDetailVCellDelegateTapClick:(FWQDetailVCell*)cell;

@end

@interface FWQDetailVCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;
@property (nonatomic, assign) LGVoicePlayState voicePlayState;
@property (nonatomic, weak) id <FWQDetailVCellDelegate>delegate;

- (void)configCellWithModel:(FWQAndADetailModel *)model subModel:(AnswerInfoListModel *)aModel indexPath:(NSIndexPath*)indexPath;
@end
