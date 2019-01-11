//
//  FWWarrantSubCommentCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantSubCommentCell.h"
#import "UILabel+LhkhAttributeTextTapAction.h"
#import "FWPersonalHomePageVC.h"
#import "FWWarrantDetailModel.h"
@interface FWWarrantSubCommentCell ()<LhkhAttributeTextTapActionDelegate>
@property (nonatomic, strong) UILabel *replyLab;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ReplyModel *rmodel;
@end

@implementation FWWarrantSubCommentCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantSubCommentCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantSubCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantSubCommentCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.replyLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
-  (void)layoutCustomViews
{
    [self.replyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate

#pragma mark - LhkhAttributeTextTapActionDelegate
- (void)lhkh_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    DLog(@"----->%@----%ld",string,index);
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.indexPath = self.indexPath;
    if (index == 0) {
        vc.faceId = self.rmodel.replyFromUserId;
    }else{
        vc.faceId = self.rmodel.replyToUserId;
    }
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

#pragma mark - Event Response


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithReply:(ReplyModel*)rmodel indexPath:(NSIndexPath*)indexPath
{
    self.indexPath = indexPath;
    self.rmodel = rmodel;
    if ([rmodel.replyType isEqualToString:@"2"]) {
        [self configCellWithReply:rmodel.replyContent userC:rmodel.replyToUser userR:rmodel.replyFromUser indexPath:indexPath];
    }else{
        [self configCellWithReply:rmodel.replyContent userC:rmodel.replyFromUser userR:@"" indexPath:indexPath];
    }
}

- (void)configCellWithReply:(NSString*)reply userC:(NSString *)userC userR:(NSString *)userR indexPath:(NSIndexPath *)indexPath
{
    NSString *replyStr = nil;
    if (userR.length>0 && userR != nil && ![userR isEqualToString:@""]) {
        
        replyStr = [NSString stringWithFormat:@"%@ 回复 %@：%@",userR,userC,reply];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:replyStr];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, userR.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(0, userR.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(userR.length+4, userC.length+1)];
        //最好设置一下行高，不设的话默认是0
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
        sty.alignment = NSTextAlignmentLeft;
        sty.lineSpacing = 2;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, replyStr.length)];
        
        self.replyLab.attributedText = attributedString;
        [self.replyLab lhkh_addAttributeTapActionWithStrings:@[userR,userC] delegate:self];
    }else if (userC.length>0 && userC != nil && ![userC isEqualToString:@""]){
        
        replyStr = [NSString stringWithFormat:@"%@：%@",userC,reply];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:replyStr];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, userC.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(0, userC.length+1)];
        //最好设置一下行高，不设的话默认是0
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
        sty.alignment = NSTextAlignmentLeft;
        sty.lineSpacing = 2;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, replyStr.length)];
        
        self.replyLab.attributedText = attributedString;
        [self.replyLab lhkh_addAttributeTapActionWithStrings:@[userC] delegate:self];
    }
}

#pragma mark - Private Methods

- (float)stringHeightWithString:(NSString *)string size:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
    
    float height = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return ceilf(height);
}

- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}


#pragma mark - Setters
- (UILabel *)replyLab
{
    if (!_replyLab) {
        _replyLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLab.textColor = Color_Black;
        _replyLab.font = systemFont(12);
        _replyLab.numberOfLines = 0;
        _replyLab.backgroundColor = [UIColor clearColor];
    }
    return _replyLab;
}

#pragma mark - Getters


@end
