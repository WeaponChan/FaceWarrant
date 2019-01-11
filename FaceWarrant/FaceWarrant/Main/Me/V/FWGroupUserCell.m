//
//  FWGroupUserCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//


#define cellWidth (Screen_W-60)/5
#import "FWGroupUserCell.h"
#import "FWAttentionModel.h"
@interface FWGroupUserCell()
@property(strong, nonatomic)UIImageView *imageView;
@property(strong, nonatomic)UILabel *userLab;
@end

@implementation FWGroupUserCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.userLab];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(cellWidth);
            make.top.left.right.equalTo(self.contentView);
        }];
        
        [self.userLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}


#pragma mark - Layout SubViews

#pragma mark - System Delegate

#pragma mark - Custom Delegate

#pragma mark - Event Response

#pragma mark - Network Requests

#pragma mark - Public Methods
+ (CGSize)cellSize
{
    return CGSizeMake(cellWidth, cellWidth+35);
}

//- (void)configCellWithModel:(FWAttentionModel*)model indexPath:(NSIndexPath*)indexPath
//{
//    if (indexPath.row == 0) {
//        self.imageView.image = Image(@"me_addFace");
//    }else{
//        self.imageView.image = Image(@"me_delFace");
//    }
//}

- (void)configCellWithData:(NSArray*)data indexPath:(NSIndexPath*)indexPath type:(NSString*)type faceGroupName:(NSString*)facegroupName
{
    if ([type isEqualToString:@"1"]) {
        self.userLab.hidden = NO;
        FWAttentionModel *model = data[indexPath.row];
        [self.imageView sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
        self.userLab.text = model.faceName;
    }else{
        if ([facegroupName isEqualToString:@"大Face"]) {
            if (indexPath.row == data.count) {
                self.imageView.image = Image(@"me_delFace");
                self.userLab.hidden = YES;
            }else{
                self.userLab.hidden = NO;
                FWAttentionModel *model = data[indexPath.row];
                [self.imageView sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
                self.userLab.text = model.faceName;
            }
        }else{
            if (indexPath.row == data.count) {
                self.imageView.image = Image(@"me_addFace");
                self.userLab.hidden = YES;
            }else if (indexPath.row == data.count + 1){
                self.imageView.image = Image(@"me_delFace");
                self.userLab.hidden = YES;
            }else{
                self.userLab.hidden = NO;
                FWAttentionModel *model = data[indexPath.row];
                [self.imageView sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
                self.userLab.text = model.faceName;
            }
        }
    }
}

#pragma mark - Private Methods

#pragma mark - Setters
- (UIImageView*)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

- (UILabel*)userLab
{
    if (_userLab == nil) {
        _userLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _userLab.textColor = Color_SubText;
        _userLab.textAlignment = NSTextAlignmentCenter;
        _userLab.font = systemFont(12);
    }
    return _userLab;
}

#pragma mark - Getters



@end
