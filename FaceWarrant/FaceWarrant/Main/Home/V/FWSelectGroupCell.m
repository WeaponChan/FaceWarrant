//
//  FWSelectGroupCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWSelectGroupCell.h"

@interface FWSelectGroupCell ()

@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UIButton *itemBtn;
@end

@implementation FWSelectGroupCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWSelectGroupCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWSelectGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWSelectGroupCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.itemBtn];
        
        [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
            make.left.equalTo(self.contentView).offset(25);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.offset(20);
            make.right.equalTo(self.contentView).offset(-25);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = Color_MainBg;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(1);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(25);
            make.right.equalTo(self.contentView).offset(-25);
        }];
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response
- (void)selectClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (self.selectblock) {
        self.selectblock(sender.selected);
    }
    if (sender.selected == YES) {
        [_itemBtn setImage:Image(@"checkBoxSel") forState:UIControlStateNormal];
    }else{
        [_itemBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
    }
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)setModel:(FWFaceLibraryClassifyModel *)model
{
    _itemLab.text = [NSString stringWithFormat:@"%@（%@）",model.groupsName,model.faceNum];
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UILabel*)itemLab
{
    if(_itemLab == nil){
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(14);
    }
    return _itemLab;
}

- (UIButton*)itemBtn
{
    if (_itemBtn == nil) {
        _itemBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_itemBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
        [_itemBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itemBtn;
}

#pragma mark - Getters


@end
