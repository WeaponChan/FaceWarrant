//
//  FWGroupItemCell.m
//  FaceWarrant
//
//  Created by LHKH on 2018/7/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWGroupItemCell.h"
#import "FWFaceLibraryClassifyModel.h"

@interface FWGroupItemCell ()
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UIButton *deleteBtn;
@property (strong, nonatomic)UIButton *editBtn;
@property (strong, nonatomic)FWFaceLibraryClassifyModel *model;
@end

@implementation FWGroupItemCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWGroupItemCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWGroupItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWGroupItemCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.editBtn];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.width.offset(150);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(30);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(30);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = Color_MainBg;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)deleteClick
{
    if ([self.delegate respondsToSelector:@selector(FWGroupItemCellDelegateClickWithModel:tag:)]) {
        [self.delegate FWGroupItemCellDelegateClickWithModel:self.model tag:0];
    }
}

- (void)editClick
{
    if ([self.delegate respondsToSelector:@selector(FWGroupItemCellDelegateClickWithModel:tag:)]) {
        [self.delegate FWGroupItemCellDelegateClickWithModel:self.model tag:1];
    }
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWFaceLibraryClassifyModel *)model indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    if (indexPath.row == 0 || indexPath.row == 1) {
        self.deleteBtn.hidden = YES;
        
        [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(30);
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(0);
        }];
        
    }else{
        self.deleteBtn.hidden = NO;
        
        [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(30);
            make.right.equalTo(self.deleteBtn.mas_left).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(30);
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    self.itemLab.textColor = Color_MainText;
    self.itemLab.text = [NSString stringWithFormat:@"%@(%@)",model.groupsName,model.faceNum];
}

#pragma mark - Private Methods
#pragma mark 获取当前View所在的ViewController
- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

#pragma mark - Setters
- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"我的face群";
        _itemLab.font = systemFont(14);
        _itemLab.textColor = Color_MainText;
    }
    return _itemLab;
}

- (UIButton *)editBtn
{
    if (_editBtn == nil) {
        _editBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_editBtn setImage:Image(@"me_edit") forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)deleteBtn
{
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_deleteBtn setImage:Image(@"me_delete") forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

#pragma mark - Getters


@end
