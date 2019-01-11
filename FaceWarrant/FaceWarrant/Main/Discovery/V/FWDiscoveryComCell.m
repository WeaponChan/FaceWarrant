//
//  FWDiscoveryComCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWDiscoveryComCell.h"
#import "LhkhCollectionView.h"
@interface FWDiscoveryComCell ()
@property (strong, nonatomic) LhkhCollectionView *faceCollectionView;
@end

@implementation FWDiscoveryComCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWDiscoveryComCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWDiscoveryComCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWDiscoveryComCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.faceCollectionView];
        [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.contentView);
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
    return 1400;
}


#pragma mark - Private Methods


#pragma mark - Setters

- (LhkhCollectionView*)faceCollectionView
{
    if (_faceCollectionView == nil) {
        _faceCollectionView = [[LhkhCollectionView alloc] initWithFrame:CGRectZero vcType:@"FWDiscoveryTypeVC" selectType:3];
    }
    return _faceCollectionView;
}

#pragma mark - Getters


@end
