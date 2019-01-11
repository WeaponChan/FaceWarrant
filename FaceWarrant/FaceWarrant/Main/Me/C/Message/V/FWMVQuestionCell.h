//
//  FWMVQuestionCell.h
//  FaceWarrantDel
//
//  Created by FW on 2018/11/12.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LGVoicePlayState){
    LGVoicePlayStateNormal,/**< 未播放状态 */
    LGVoicePlayStateDownloading,/**< 正在下载中 */
    LGVoicePlayStatePlaying,/**< 正在播放 */
    LGVoicePlayStateCancel,/**< 播放被取消 */
};
@class FWMessageAModel,FWMVQuestionCell;

@protocol FWMVQuestionCellDelegate <NSObject>

- (void)FWMVQuestionCellDelegateTapClick:(FWMVQuestionCell*)cell;

@end
@interface FWMVQuestionCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)configCellWithModel:(FWMessageAModel*)model;
@property (nonatomic, assign) LGVoicePlayState voicePlayState;
@property (nonatomic, weak)id<FWMVQuestionCellDelegate>delegate;
@end
