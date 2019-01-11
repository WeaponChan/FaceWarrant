//
//  FWSearchCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWSearchCell.h"
#import "LhkhTagView.h"
#import "LhkhTag.h"
#import "FWSearchHotModel.h"
#import "FWSearchHistoryModel.h"
@interface FWSearchCell ()
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UIButton *clearBtn;
@property (strong, nonatomic)LhkhTagView *tagView;
@property (strong, nonatomic)NSMutableArray *dataSource;

@end

@implementation FWSearchCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWSearchCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWSearchCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.clearBtn];
        [self.contentView addSubview:self.tagView];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)clearClick
{
    if ([self.delegate respondsToSelector:@selector(FWSearchCellDelegateClearAction)]) {
        [self.delegate FWSearchCellDelegateClearAction];
    }
}


#pragma mark - Network requests




#pragma mark - Public Methods

- (void)configCellWithData:(NSMutableArray*)data indexPath:(NSIndexPath*)indexPath type:(NSString*)type
{
    [self.tagView removeAllTags];
    self.dataSource = data;
    if ([type isEqualToString:@"1"]) {
        self.itemLab.text = @"热门搜索";
        self.clearBtn.hidden = YES;
    }else{
        if (indexPath.section == 0) {
            self.itemLab.text = @"历史搜索";
            self.clearBtn.hidden = NO;
        }else{
            self.itemLab.text = @"热门搜索";
            self.clearBtn.hidden = YES;
        }
    }
    
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LhkhTag *tag = nil;
    
        if ([type isEqualToString:@"1"]) {
            FWSearchHotModel *model = self.dataSource[idx];
            tag = [[LhkhTag alloc] initWithText:model.searchCondition];
        }else{
            if (indexPath.section == 0) {
                FWSearchHistoryModel *model = self.dataSource[idx];
                tag = [[LhkhTag alloc] initWithText:model.searchContent];
            }else{
                FWSearchHotModel *model = self.dataSource[idx];
                tag = [[LhkhTag alloc] initWithText:model.searchCondition];
            }
        }
        tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
        tag.cornerRadius = 12.5f;
        tag.font = [UIFont systemFontOfSize:13];
        tag.borderWidth = 1;
        tag.bgColor = Color_White;
        tag.borderColor = [UIColor colorWithHexString:@"#eeeeee"];
        tag.textColor = RGB_COLOR(53, 53, 53);
        tag.enable = YES;
        [self.tagView addTag:tag];
    }];
    LhkhWeakSelf(self);
    self.tagView.didTapTagAtIndex = ^(NSUInteger idx,NSString *idxText){
        NSLog(@"点击了第%ld个--->%@",idx,idxText);
        if ([weakself.delegate respondsToSelector:@selector(FWSearchCellDelegateItemClick:)]) {
            [weakself.delegate FWSearchCellDelegateItemClick:idxText];
        }
    };
    CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
    [self.itemLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    [self.clearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.offset(tagHeight);
        make.top.equalTo(self.itemLab.mas_bottom).offset(15);
    }];
}

- (CGFloat)configCellHeightWithData:(NSMutableArray*)data indexPath:(NSIndexPath*)indexPath type:(NSString*)type
{
    [self.tagView removeAllTags];
    self.dataSource = data;
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LhkhTag *tag = nil;
        if ([type isEqualToString:@"1"]) {
            FWSearchHotModel *model = self.dataSource[idx];
            tag = [[LhkhTag alloc] initWithText:model.searchCondition];
        }else{
            if (indexPath.section == 0) {
                FWSearchHistoryModel *model = self.dataSource[idx];
                tag = [[LhkhTag alloc] initWithText:model.searchContent];
            }else{
                FWSearchHotModel *model = self.dataSource[idx];
                tag = [[LhkhTag alloc] initWithText:model.searchCondition];
            }
        }
        
        tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
        tag.cornerRadius = 12.5f;
        tag.font = [UIFont systemFontOfSize:13];
        tag.borderWidth = 1;
        tag.bgColor = Color_White;
        tag.borderColor = [UIColor colorWithHexString:@"#eeeeee"];
        tag.textColor = RGB_COLOR(53, 53, 53);
        tag.enable = YES;
        [self.tagView addTag:tag];
    }];
    CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
    return tagHeight+40;
}

#pragma mark - Private Methods


#pragma mark - Setters

- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.font = systemFont(14);
    }
    return _itemLab;
}

- (UIButton*)clearBtn
{
    if (_clearBtn == nil) {
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_clearBtn setImage:Image(@"search_clear") forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = systemFont(14);
        [_clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (LhkhTagView*)tagView
{
    if (_tagView == nil) {
        _tagView = [[LhkhTagView alloc] init];
        _tagView.padding = UIEdgeInsetsMake(0, 10, 10, 10);
        _tagView.lineSpacing = 10;
        _tagView.interitemSpacing = 10;
        _tagView.preferredMaxLayoutWidth = Screen_W;
    }
    return _tagView;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


#pragma mark - Getters



@end
