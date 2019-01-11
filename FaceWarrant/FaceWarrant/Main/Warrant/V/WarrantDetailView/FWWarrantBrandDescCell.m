//
//  FWWarrantBrandDescCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantBrandDescCell.h"
#import "FWWarrantDetailModel.h"
@interface FWWarrantBrandDescCell ()
@property (strong ,nonatomic)UIImageView *itemImg;
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *itemSubLab;
@property (strong, nonatomic)UIButton *expandBtn;
@property (strong, nonatomic)NSIndexPath *indexPath;
@end

@implementation FWWarrantBrandDescCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantBrandDescCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantBrandDescCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantBrandDescCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.contentView addSubview:self.itemImg];
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.itemSubLab];
        [self.contentView addSubview:self.expandBtn];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.top.equalTo(self.contentView).offset(10);
    }];

    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.self.itemImg.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.itemSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.itemLab.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.expandBtn.mas_top).offset(-10);
    }];
    
    [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.top.equalTo(self.itemSubLab.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)expandClick
{
    if ([self.delegate respondsToSelector:@selector(FWWarrantBrandDescCellDelegateExpandClickWithIndexPath:)]) {
        [self.delegate FWWarrantBrandDescCellDelegateExpandClickWithIndexPath:self.indexPath];
    }
}
#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 120;
}

- (void)configCellWithModel:(FWWarrantDetailModel *)model indexPath:(NSIndexPath*)indexPath
{
    
    self.indexPath = indexPath;
    self.itemSubLab.text = model.brandSynopsis;
   
    float msgHeight = [self stringHeightWithString:model.brandSynopsis size:12 maxWidth: Screen_W-20];
    if(msgHeight <=40){
        self.expandBtn.hidden = YES;
    }else{
        self.expandBtn.hidden = NO;
    }
    
    if (model.isExpand) {
        [self.expandBtn setImage:Image(@"warrant_shang_gray") forState:UIControlStateNormal];
    }else{
        [self.expandBtn setImage:Image(@"warrant_xia_gray") forState:UIControlStateNormal];
    }
    
//    if (self.itemSubLab.text.length>0) {
//        [UILabel changeSpaceForLabel:self.itemSubLab withLineSpace:5 WordSpace:0];
//    }
    
    self.expandBtn.selected = model.isExpand;
}

#pragma mark - Private Methods

- (float)stringHeightWithString:(NSString *)string size:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
    
    float height = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return ceilf(height);
}

#pragma mark - Setters
- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _itemImg.image = [UIImage imageNamed:@"warrant_brand"];
    }
    return _itemImg;
}

- (UILabel *)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"品牌介绍";
        _itemLab.font = systemFont(15);
        _itemLab.textColor = Color_Black;
    }
    return _itemLab;
}

- (UILabel *)itemSubLab
{
    if (_itemSubLab == nil) {
        _itemSubLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemSubLab.text = @"";
        _itemSubLab.font = systemFont(14);
        _itemSubLab.textColor = Color_Black;
        _itemSubLab.numberOfLines = 0;
    }
    return _itemSubLab;
}

- (UIButton*)expandBtn
{
    if (_expandBtn == nil) {
        _expandBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_expandBtn addTarget:self action:@selector(expandClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expandBtn;
}

#pragma mark - Getters


@end
