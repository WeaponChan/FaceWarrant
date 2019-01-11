//
//  FWMyWarrantCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMyWarrantCell.h"
#import "FWFaceReleaseModel.h"
@interface FWMyWarrantCell()<UIAlertViewDelegate>
{
    NSString *_netWorkStatus;
}
@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UIButton *playBtn;
@property (strong, nonatomic)FWFaceReleaseModel *model;
@end


@implementation FWMyWarrantCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.playBtn];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.contentView);
        }];
        
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.offset(30);
            make.centerX.equalTo(self.imageView.mas_centerX);
            make.centerY.equalTo(self.imageView.mas_centerY);
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
    return CGSizeMake(0, 0);
}

- (void)configCellWithModel:(FWFaceReleaseModel *)model indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    if ([model.modelType isEqualToString:@"1"]) {
        self.playBtn.hidden = NO;
    }else{
        self.playBtn.hidden = YES;
    }
    [self.imageView sd_setImageWithURL:URL(model.modelUrl) placeholderImage:nil];
}


#pragma mark - Private Methods



#pragma mark - Setters
- (UIImageView*)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"2"];
    }
    return _imageView;
}

- (UIButton *)playBtn
{
    if (_playBtn == nil) {
        _playBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_playBtn setImage:Image(@"warrant_play") forState:UIControlStateNormal];
        _playBtn.userInteractionEnabled = NO;
    }
    return _playBtn;
}


#pragma mark - Getters



@end
