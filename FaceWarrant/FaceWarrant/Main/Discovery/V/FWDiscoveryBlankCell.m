//
//  FWDiscoveryBlankCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWDiscoveryBlankCell.h"

@interface FWDiscoveryBlankCell ()
@property (strong, nonatomic) UIView *blankView;
@end

@implementation FWDiscoveryBlankCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWDiscoveryBlankCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWDiscoveryBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWDiscoveryBlankCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.blankView = [[UIView alloc] initWithFrame:CGRectZero];
        self.blankView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.blankView];
        
        UIImageView *blankImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        blankImg.image = Image(@"tip_Content");
        [self.blankView addSubview:blankImg];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"空空如也~";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = systemFont(14);
        label.textColor = Color_SubText;
        [self.blankView addSubview:label];
        
        
        [self.blankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
        
        [blankImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.offset(150);
            make.top.equalTo(self.blankView).offset(25);
            make.centerX.equalTo(self.blankView.mas_centerX);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
            make.top.equalTo(blankImg.mas_bottom).offset(25);
            make.centerX.equalTo(self.blankView.mas_centerX);
            make.left.right.equalTo(self.blankView);
        }];
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 240;
}


#pragma mark - Private Methods


#pragma mark - Setters


#pragma mark - Getters


@end
