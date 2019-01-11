//
//  FWSearchFaceCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWSearchFaceCell.h"
#import "FWSearchFaceCCell.h"
#import "FWSearchFaceModel.h"
#define cellWidth (Screen_W-30)/2
@interface FWSearchFaceCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)NSMutableArray *dataList;
@end

@implementation FWSearchFaceCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWSearchFaceCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWSearchFaceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWSearchFaceCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.contentView);
        }];
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWSearchFaceCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWSearchFaceCCell class]) forIndexPath:indexPath];
    FWSearchFaceModel *model = self.dataList[indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWSearchFaceCCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.navigationController pushViewController:[FWPersonalHomePageVC new] animated:NO];
}

#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network requests


#pragma mark - Public Methods

+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithData:(NSArray*)data indexPath:(NSIndexPath*)indexPath
{
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:data];
    [self.collectionView reloadData];
    
}

- (CGFloat)configCellHeightWithData:(NSArray*)data indexPath:(NSIndexPath*)indexPath
{
    NSInteger z = (data.count+1)/2;
    return (cellWidth+70)*z;
}


#pragma mark - Private Methods


#pragma mark - Setters
- (UICollectionView*)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);//分区内边距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FWSearchFaceCCell class] forCellWithReuseIdentifier:NSStringFromClass([FWSearchFaceCCell class])];
    }
    return _collectionView;
}

- (NSMutableArray*)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark - Getters


@end
