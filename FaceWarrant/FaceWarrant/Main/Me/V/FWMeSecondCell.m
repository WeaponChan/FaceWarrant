//
//  FWMeSecondCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/16.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMeSecondCell.h"
#import "FWMeInfoModel.h"
@interface FWMeSecondCell ()
@property (weak, nonatomic) IBOutlet UILabel *attenLab;
@property (weak, nonatomic) IBOutlet UILabel *warrantLab;
@property (weak, nonatomic) IBOutlet UILabel *collectLab;
@property (strong, nonatomic)FWMeInfoModel *model;
@end

@implementation FWMeSecondCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMeSecondCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMeSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib
{
    [super awakeFromNib];

}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)cellBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(FWMeSecondCellDelegateWith:)]) {
        [self.delegate FWMeSecondCellDelegateWith:sender.tag];
    }
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 70;
}

- (void)configCellWithModel:(FWMeInfoModel*)model
{
    self.model = model;
    self.attenLab.text = self.model.attentionCount;
    self.warrantLab.text = self.model.releaseGoodsCount;
    self.collectLab.text = self.model.collectionCount;
}

#pragma mark - Private Methods


#pragma mark - Setters


#pragma mark - Getters


@end
