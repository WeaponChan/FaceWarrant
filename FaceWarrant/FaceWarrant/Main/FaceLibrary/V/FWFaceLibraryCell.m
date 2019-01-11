//
//  FWFaceLibraryCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/16.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceLibraryCell.h"
#import "UIButton+Lhkh.h"
#import "FWFaceLibraryModel.h"
#import "FWPersonalHomePageVC.h",
#define cellH 120*Screen_W/375
@interface FWFaceLibraryCell ()
@property (strong, nonatomic)UIView *cview;
@property (strong, nonatomic)UIImageView *faceImg;
@property (strong, nonatomic)UILabel *faceLab;
@property (strong, nonatomic)UIButton *fansBtn;
@property (strong, nonatomic)UIButton *warrantBtn;
@property (strong, nonatomic)UIButton *zanBtn;
@property (strong, nonatomic)UILabel *taLab;
@property (strong, nonatomic)UIButton *moreBtn;
@property (strong, nonatomic)UILabel *hasNewgoodsLab;
@property (strong, nonatomic)UIView  *releaseGoodsView;
@property (strong, nonatomic)UIImageView  *releaseGoodsImageView;
@property (strong, nonatomic)UIImageView *goodsImg1;
@property (strong, nonatomic)UIImageView *goodsImg2;
@property (strong, nonatomic)UIImageView *goodsImg3;
@property (strong, nonatomic)UIImageView *goodsImg4;
@property (strong, nonatomic)UIImageView *goodsImg5;
@property (strong, nonatomic)FWFaceLibraryModel *model;
@end

@implementation FWFaceLibraryCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWFaceLibraryCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWFaceLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWFaceLibraryCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.cview.layer.cornerRadius = 5.f;
        self.cview.layer.masksToBounds = YES;
        self.cview.backgroundColor = Color_White;
        [self.contentView addSubview:self.cview];
        [self.cview addSubview:self.faceImg];
        [self.cview addSubview:self.faceLab];
        [self.cview addSubview:self.fansBtn];
        [self.cview addSubview:self.warrantBtn];
//        [self.contentView addSubview:self.zanBtn];
//        [self.cview addSubview:self.taLab];
        [self.cview addSubview:self.releaseGoodsView];
        [self.cview addSubview:self.moreBtn];
        [self.cview addSubview:self.hasNewgoodsLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.cview mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.contentView).offset(5);
         make.top.equalTo(self.contentView);
         make.bottom.equalTo(self.contentView).offset(-10);
         make.right.equalTo(self.contentView).offset(-5);
    }];
    
    [self.faceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.cview);
        make.bottom.equalTo(self.cview);
        make.width.offset(cellH);
    }];
    
//    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(20);
//        make.right.equalTo(self.contentView).offset(-10);
//        make.top.equalTo(self.faceImg).offset(10);
//    }];
//    [self.zanBtn changeImageAndTitle];
    
    [self.warrantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.right.equalTo(self.cview).offset(-10);
        make.top.equalTo(self.faceImg).offset(10);
    }];
    
    [self.fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.right.equalTo(self.warrantBtn.mas_left).offset(-10);
        make.top.equalTo(self.faceImg).offset(10);
    }];
    
    [self.faceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        if (IS_iPhone_5) {
            make.width.offset(70);
        }else{
            make.width.offset(90);
        }
        make.left.equalTo(self.faceImg.mas_right).offset(10);
//        make.right.equalTo(self.fansBtn.mas_left).offset(-5);
        make.top.equalTo(self.faceImg).offset(10);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cview).offset(-10);
        make.height.width.offset(24);
        make.bottom.equalTo(self.cview).offset(-20);
    }];
    
    [self.releaseGoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(110);
        make.right.equalTo(self.moreBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.moreBtn.mas_centerY);
    }];
    
    [self.hasNewgoodsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.top.equalTo(self.faceImg).offset(5);
        make.right.equalTo(self.faceImg).offset(-5);
    }];
//    [self.taLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(20);
//        make.left.equalTo(self.faceImg.mas_right).offset(10);
//        make.centerY.equalTo(self.moreBtn.mas_centerY);
//    }];
}


//- (void)prepareForReuse {
//
//    [super prepareForReuse];
//    self.releaseGoodsView = nil;
//    self.goodsImg1.image = nil;
//    self.goodsImg2.image = nil;
//    self.goodsImg3.image = nil;
//    self.goodsImg4.image = nil;
//}

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response
- (void)moreClick
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = self.model.faceId;
    [[self superViewController:self].navigationController pushViewController:vc animated:YES];
}

#pragma mark - Network requests


#pragma mark - Public Methods

+ (CGFloat)cellHeight
{
    return cellH;
}

- (void)configCellWithModel:(FWFaceLibraryModel*)model indexPath:(NSIndexPath*)indexPath selectType:(NSString*)selectType
{
    self.model = model;
    [self.faceImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder100];
    self.faceLab.text = model.faceName;
    [self.fansBtn setTitle:StringConnect(@"粉丝:", model.fansCount) forState:UIControlStateNormal];
    [self.warrantBtn setTitle:StringConnect(@"碑它:", model.releaseGoodsCount) forState:UIControlStateNormal];
    if (model.hasnewReleaseGoodsCount.floatValue>0) {
        self.hasNewgoodsLab.hidden = NO;
        if (model.hasnewReleaseGoodsCount.floatValue>99) {
            self.hasNewgoodsLab.text = @"99+";
            [self.hasNewgoodsLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(20);
                make.width.offset(30);
                make.top.equalTo(self.faceImg).offset(5);
                make.right.equalTo(self.faceImg).offset(-5);
            }];
        }else{
            self.hasNewgoodsLab.text = model.hasnewReleaseGoodsCount;
        }
    }else{
        self.hasNewgoodsLab.hidden = YES;
    }
    
    self.moreBtn.hidden = self.model.releaseGoodsList.count<5;
    if (self.model.releaseGoodsList.count<5) {
        [self.moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cview).offset(-10);
            make.height.width.offset(0);
            make.bottom.equalTo(self.cview).offset(-20);
        }];
        
        [self.releaseGoodsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.width.offset(110);
            make.right.equalTo(self.moreBtn.mas_left);
            make.centerY.equalTo(self.moreBtn.mas_centerY);
        }];
    }else{
        [self.moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cview).offset(-10);
            make.height.width.offset(24);
            make.bottom.equalTo(self.cview).offset(-20);
        }];
        
        [self.releaseGoodsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.width.offset(110);
            make.right.equalTo(self.moreBtn.mas_left).offset(-10);
            make.centerY.equalTo(self.moreBtn.mas_centerY);
        }];
    }
    
    if (model.releaseGoodsList.count>0) {
        self.releaseGoodsView.hidden = NO;
        CGFloat w = 30;
        CGFloat h = 30;
        
//        for (int i =0 ; i<model.releaseGoodsList.count; i++) {
//            self.releaseGoodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20*i, 0, w, h)];
//            FaceLibReleaseGoodsListModel *mModel = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[0]];
//            [self.releaseGoodsImageView sd_setImageWithURL:URL(mModel.modelUrl) placeholderImage:Image_placeHolder];
//            [self.releaseGoodsView addSubview:self.releaseGoodsImageView];
//        }

    
        if (model.releaseGoodsList.count == 1) {
            self.goodsImg1.hidden = NO;
            self.goodsImg2.hidden = YES;
            self.goodsImg3.hidden = YES;
            self.goodsImg4.hidden = YES;
            self.goodsImg5.hidden = YES;
            FaceLibReleaseGoodsListModel *mModel1 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[0]];
            self.goodsImg1.frame = CGRectMake(80, 0, w, h);
            [self.goodsImg1 sd_setImageWithURL:URL(mModel1.modelUrl) placeholderImage:Image_placeHolder66];
            [self.releaseGoodsView addSubview:self.goodsImg1];
            
            
        }else if (model.releaseGoodsList.count == 2){
            self.goodsImg1.hidden = NO;
            self.goodsImg2.hidden = NO;
            self.goodsImg3.hidden = YES;
            self.goodsImg4.hidden = YES;
            self.goodsImg5.hidden = YES;
            [self.releaseGoodsView addSubview:self.goodsImg1];
            [self.releaseGoodsView addSubview:self.goodsImg2];
            FaceLibReleaseGoodsListModel *mModel1 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[0]];
            FaceLibReleaseGoodsListModel *mModel2 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[1]];
            self.goodsImg1.frame = CGRectMake(80, 0, w, h);
            [self.goodsImg1 sd_setImageWithURL:URL(mModel2.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg2.frame = CGRectMake(60, 0, w, h);
            [self.goodsImg2 sd_setImageWithURL:URL(mModel1.modelUrl) placeholderImage:Image_placeHolder66];

        }else if (model.releaseGoodsList.count == 3){
            self.goodsImg1.hidden = NO;
            self.goodsImg2.hidden = NO;
            self.goodsImg3.hidden = NO;
            self.goodsImg4.hidden = YES;
            self.goodsImg5.hidden = YES;
            [self.releaseGoodsView addSubview:self.goodsImg1];
            [self.releaseGoodsView addSubview:self.goodsImg2];
            [self.releaseGoodsView addSubview:self.goodsImg3];
            FaceLibReleaseGoodsListModel *mModel1 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[0]];
            FaceLibReleaseGoodsListModel *mModel2 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[1]];
            FaceLibReleaseGoodsListModel *mModel3 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[2]];
            self.goodsImg1.frame = CGRectMake(80, 0, w, h);
            [self.goodsImg1 sd_setImageWithURL:URL(mModel3.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg2.frame = CGRectMake(60, 0, w, h);
            [self.goodsImg2 sd_setImageWithURL:URL(mModel2.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg3.frame = CGRectMake(40, 0, w, h);
            [self.goodsImg3 sd_setImageWithURL:URL(mModel1.modelUrl) placeholderImage:Image_placeHolder66];
            
            
        }else if (model.releaseGoodsList.count == 4){
            self.goodsImg1.hidden = NO;
            self.goodsImg2.hidden = NO;
            self.goodsImg3.hidden = NO;
            self.goodsImg4.hidden = NO;
            self.goodsImg5.hidden = YES;
            [self.releaseGoodsView addSubview:self.goodsImg1];
            [self.releaseGoodsView addSubview:self.goodsImg2];
            [self.releaseGoodsView addSubview:self.goodsImg3];
            [self.releaseGoodsView addSubview:self.goodsImg4];
            FaceLibReleaseGoodsListModel *mModel1 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[0]];
            FaceLibReleaseGoodsListModel *mModel2 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[1]];
            FaceLibReleaseGoodsListModel *mModel3 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[2]];
            FaceLibReleaseGoodsListModel *mModel4 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[3]];
            self.goodsImg1.frame = CGRectMake(80, 0, w, h);
            [self.goodsImg1 sd_setImageWithURL:URL(mModel4.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg2.frame = CGRectMake(60, 0, w, h);
            [self.goodsImg2 sd_setImageWithURL:URL(mModel3.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg3.frame = CGRectMake(40, 0, w, h);
            [self.goodsImg3 sd_setImageWithURL:URL(mModel3.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg4.frame = CGRectMake(20, 0, w, h);
            [self.goodsImg4 sd_setImageWithURL:URL(mModel1.modelUrl) placeholderImage:Image_placeHolder66];
            
        }else if (model.releaseGoodsList.count == 5){
            self.goodsImg1.hidden = NO;
            self.goodsImg2.hidden = NO;
            self.goodsImg3.hidden = NO;
            self.goodsImg4.hidden = NO;
            self.goodsImg5.hidden = NO;
            [self.releaseGoodsView addSubview:self.goodsImg1];
            [self.releaseGoodsView addSubview:self.goodsImg2];
            [self.releaseGoodsView addSubview:self.goodsImg3];
            [self.releaseGoodsView addSubview:self.goodsImg4];
            [self.releaseGoodsView addSubview:self.goodsImg5];
            FaceLibReleaseGoodsListModel *mModel1 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[0]];
            FaceLibReleaseGoodsListModel *mModel2 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[1]];
            FaceLibReleaseGoodsListModel *mModel3 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[2]];
            FaceLibReleaseGoodsListModel *mModel4 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[3]];
            FaceLibReleaseGoodsListModel *mModel5 = [FaceLibReleaseGoodsListModel mj_objectWithKeyValues:model.releaseGoodsList[4]];
            self.goodsImg1.frame = CGRectMake(80, 0, w, h);
            [self.goodsImg1 sd_setImageWithURL:URL(mModel5.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg2.frame = CGRectMake(60, 0, w, h);
            [self.goodsImg2 sd_setImageWithURL:URL(mModel4.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg3.frame = CGRectMake(40, 0, w, h);
            [self.goodsImg3 sd_setImageWithURL:URL(mModel3.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg4.frame = CGRectMake(20, 0, w, h);
            [self.goodsImg4 sd_setImageWithURL:URL(mModel2.modelUrl) placeholderImage:Image_placeHolder66];
            self.goodsImg5.frame = CGRectMake(0, 0, w, h);
            [self.goodsImg5 sd_setImageWithURL:URL(mModel1.modelUrl) placeholderImage:Image_placeHolder66];
            
        }
        
    }else{
        self.releaseGoodsView.hidden = YES;
        self.goodsImg1.hidden = YES;
        self.goodsImg2.hidden = YES;
        self.goodsImg3.hidden = YES;
        self.goodsImg4.hidden = YES;
        self.goodsImg5.hidden = YES;
    }
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

- (UIView*)cview
{
    if (_cview == nil) {
        _cview = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _cview;
}

- (UIImageView*)faceImg
{
    if (_faceImg == nil) {
        _faceImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _faceImg;
}

- (UILabel*)faceLab
{
    if (_faceLab == nil) {
        _faceLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _faceLab.textColor = Color_MainText;
        _faceLab.font = systemFont(14);
    }
    return _faceLab;
}

- (UIButton*)warrantBtn
{
    if (_warrantBtn == nil) {
        _warrantBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_warrantBtn setImage:[UIImage imageNamed:@"faceLib_warrant"] forState:UIControlStateNormal];
        [_warrantBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
        _warrantBtn.titleLabel.font = systemFont(10);
        _warrantBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _warrantBtn;
}

- (UIButton*)fansBtn
{
    if (_fansBtn == nil) {
        _fansBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_fansBtn setImage:[UIImage imageNamed:@"faceLib_fans"] forState:UIControlStateNormal];
        [_fansBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
        _fansBtn.titleLabel.font = systemFont(10);
        _fansBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _fansBtn;
}

- (UIButton*)moreBtn
{
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_moreBtn setImage:[UIImage imageNamed:@"faceLib_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}


- (UILabel*)taLab
{
    if (_taLab == nil) {
        _taLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _taLab.text = @"TA的碑它";
        _taLab.textColor = Color_SubText;
        _taLab.font = systemFont(14);
    }
    return _taLab;
}


- (UIView*)releaseGoodsView
{
    if (_releaseGoodsView == nil) {
        _releaseGoodsView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _releaseGoodsView;
}

- (UIImageView*)goodsImg1
{
    if (_goodsImg1 == nil) {
        _goodsImg1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImg1.layer.cornerRadius = 15.f;
        _goodsImg1.layer.masksToBounds = YES;
        _goodsImg1.layer.borderColor = [UIColor colorWithHexString:@"#bbbbbb"].CGColor;
        _goodsImg1.layer.borderWidth = 1.f;
    }
    return _goodsImg1;
}

- (UIImageView*)goodsImg2
{
    if (_goodsImg2 == nil) {
        _goodsImg2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImg2.layer.cornerRadius = 15.f;
        _goodsImg2.layer.masksToBounds = YES;
        _goodsImg2.layer.borderColor = [UIColor colorWithHexString:@"#bbbbbb"].CGColor;
        _goodsImg2.layer.borderWidth = 1.f;
    }
    return _goodsImg2;
}


- (UIImageView*)goodsImg3
{
    if (_goodsImg3 == nil) {
        _goodsImg3 = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImg3.layer.cornerRadius = 15.f;
        _goodsImg3.layer.masksToBounds = YES;
        _goodsImg3.layer.borderColor = [UIColor colorWithHexString:@"#bbbbbb"].CGColor;
        _goodsImg3.layer.borderWidth = 1.f;
    }
    return _goodsImg3;
}


- (UIImageView*)goodsImg4
{
    if (_goodsImg4 == nil) {
        _goodsImg4 = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImg4.layer.cornerRadius = 15.f;
        _goodsImg4.layer.masksToBounds = YES;
        _goodsImg4.layer.borderColor = [UIColor colorWithHexString:@"#bbbbbb"].CGColor;
        _goodsImg4.layer.borderWidth = 1.f;
    }
    return _goodsImg4;
}

- (UIImageView*)goodsImg5
{
    if (_goodsImg5 == nil) {
        _goodsImg5 = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImg5.layer.cornerRadius = 15.f;
        _goodsImg5.layer.masksToBounds = YES;
        _goodsImg5.layer.borderColor = [UIColor colorWithHexString:@"#bbbbbb"].CGColor;
        _goodsImg5.layer.borderWidth = 1.f;
    }
    return _goodsImg5;
}

- (UILabel*)hasNewgoodsLab
{
    if (_hasNewgoodsLab == nil) {
        _hasNewgoodsLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _hasNewgoodsLab.layer.cornerRadius = 10.f;
        _hasNewgoodsLab.layer.masksToBounds = YES;
        _hasNewgoodsLab.backgroundColor = [UIColor redColor];
        _hasNewgoodsLab.textColor = Color_White;
        _hasNewgoodsLab.textAlignment = NSTextAlignmentCenter;
        _hasNewgoodsLab.font = systemFont(10);
    }
    return _hasNewgoodsLab;
}

#pragma mark - Getters


@end
