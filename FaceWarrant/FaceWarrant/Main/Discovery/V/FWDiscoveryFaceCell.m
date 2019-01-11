//
//  FWDiscoveryFaceCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWDiscoveryFaceCell.h"
#import "UIButton+Lhkh.h"
#import "SDCycleScrollView.h"
#import "FWDiscoveryModel.h"
//#import "FWWarrantDetailVC.h"
#import "FWPersonalHomePageVC.h"
#define cellWidth (Screen_W-30)/2
@interface FWDiscoveryFaceCell()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *faceNameLab;
@property (nonatomic, strong) UIButton *faceAttenBtn;
@property (nonatomic, strong) NSArray *releasegoodsArr;
@end

@implementation FWDiscoveryFaceCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        [self addSubview:self.bannerView];
        [self.contentView addSubview:self.faceImageView];
        [self.contentView addSubview:self.faceNameLab];
        [self.contentView addSubview:self.faceAttenBtn];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(cellWidth);
//        make.height.offset(0.778*cellWidth);
        make.left.right.top.equalTo(self.contentView);
    }];
    
    [self.faceNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self.faceImageView.mas_bottom).offset(15);
        make.right.equalTo(self.faceAttenBtn.mas_left);
    }];
    
    [self.faceAttenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.width.offset(50);
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.faceNameLab.mas_centerY);
    }];
//    [self.faceAttenBtn changeImageAndTitle];
    
    
}
#pragma mark - System Delegate

#pragma mark - Custom Delegate

#pragma mark - Event Response

#pragma mark - Network Requests

#pragma mark - Public Methods
+ (CGSize)cellSize
{
    return CGSizeMake(cellWidth, cellWidth+45);
}

- (void)configCellWithData:(FWDiscoveryModel*)model;
{
    self.faceNameLab.text = model.faceName;
    [self.faceAttenBtn setTitle:model.favoriteCount forState:UIControlStateNormal];
    self.releasegoodsArr = [ReleaseGoodsListModel mj_objectArrayWithKeyValuesArray:model.releaseGoodsList];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i<self.releasegoodsArr.count; i++) {
        ReleaseGoodsListModel *rModel = self.releasegoodsArr[i];
        NSString *imgurl = rModel.modelUrl;
        [imageArr addObject:imgurl];
    }
    self.bannerView.imageURLStringsGroup = imageArr;
    
//    LhkhWeakSelf(self);
//    self.bannerView.clickItemOperationBlock = ^(NSInteger currentIndex) {
//        FWPersonalHomePageVC *vc = [[FWPersonalHomePageVC alloc] init];
//        vc.faceId = model.faceId;
//        [[weakself superViewController:weakself].navigationController pushViewController:vc animated:YES];
//    };
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

- (UIImageView*)faceImageView
{
    if (_faceImageView == nil) {
        _faceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _faceImageView;
}

- (UILabel*)faceNameLab
{
    if (_faceNameLab == nil) {
        _faceNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _faceNameLab.textColor = Color_MainText;
        _faceNameLab.font = systemFont(14);
    }
    return _faceNameLab;
}

- (UIButton*)faceAttenBtn
{
    if (_faceAttenBtn == nil) {
        _faceAttenBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_faceAttenBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _faceAttenBtn.titleLabel.font = systemFont(10);
        _faceAttenBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居右显示
        [_faceAttenBtn setImage:[UIImage imageNamed:@"discovery_xiao"] forState:UIControlStateNormal];
        _faceAttenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    }
    return _faceAttenBtn;
}

- (SDCycleScrollView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, cellWidth, cellWidth) delegate:self placeholderImage:nil];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.pageDotColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _bannerView.currentPageDotColor = [UIColor whiteColor];
        _bannerView.autoScrollTimeInterval = 2;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _bannerView.userInteractionEnabled = NO;
    }
    return _bannerView;
}

- (NSArray*)releasegoodsArr
{
    if (_releasegoodsArr == nil) {
        _releasegoodsArr = [NSArray array];
    }
    return _releasegoodsArr;
}

#pragma mark - Getters



@end
