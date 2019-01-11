//
//  FWMeVoiceAnswerCell.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

typedef NS_ENUM(NSUInteger, LGVoicePlayState){
    LGVoicePlayStateNormal,/**< 未播放状态 */
    LGVoicePlayStateDownloading,/**< 正在下载中 */
    LGVoicePlayStatePlaying,/**< 正在播放 */
    LGVoicePlayStateCancel,/**< 播放被取消 */
};

#import <UIKit/UIKit.h>
@class FWMeAnswerModel,FWMeVoiceAnswerCell;

@protocol FWMeVoiceAnswerCellDelegate <NSObject>

- (void)FWMeVoiceAnswerCellDelegateTapClick:(FWMeVoiceAnswerCell*)cell;

@end

@interface FWMeVoiceAnswerCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@property (nonatomic, assign) LGVoicePlayState voicePlayState;
- (void)configCellWithModel:(FWMeAnswerModel*)model indexPath:(NSIndexPath*)indexPath;
@property (nonatomic, weak)id<FWMeVoiceAnswerCellDelegate>delegate;
@end
