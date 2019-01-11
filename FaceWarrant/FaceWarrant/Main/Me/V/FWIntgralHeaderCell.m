//
//  FWIntgralHeaderCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/21.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWIntgralHeaderCell.h"
#import "FWIntegralModel.h"
#import "FWIntegralConversionVC.h"
#import "FWIntegralRuleVC.h"
@interface FWIntgralHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *integralLab;
@property (weak, nonatomic) IBOutlet UIButton *duihuanBtn;
@property (strong, nonatomic)FWIntegralModel *model;
@end

@implementation FWIntgralHeaderCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWIntgralHeaderCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWIntgralHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.duihuanBtn.layer.cornerRadius = 5.f;
    self.duihuanBtn.layer.masksToBounds = YES;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)backClick:(UIButton *)sender {
    [[self superViewController:self].navigationController popViewControllerAnimated:YES];
}

- (IBAction)ruleClick:(UIButton *)sender {
    FWIntegralRuleVC *vc = [FWIntegralRuleVC new];
    vc.integralStr = self.model.remainderPoints;
    vc.integralSubStr = self.model.pointsBase;
    vc.pointsRegister = self.model.pointsRegister;
    vc.integralRuleSubStr = self.model.pointsPercent;
    [[self superViewController:self].navigationController pushViewController:vc animated:YES];
}

- (IBAction)duihuanClick:(UIButton *)sender {
    FWIntegralConversionVC *vc = [FWIntegralConversionVC new];
    vc.integralStr = self.model.remainderPoints;
    vc.integralSubStr = self.model.pointsPercent;//兑换的比例
    [[self superViewController:self].navigationController pushViewController:vc animated:YES];
}
#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 250;
}

- (void)configCellWithModel:(FWIntegralModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    self.integralLab.text = model.remainderPoints;
}

#pragma mark - Private Methods

- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

#pragma mark - Setters


#pragma mark - Getters


@end
