//
//  FWClassifyTypeVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWClassifyTypeVC.h"
#import "LhkhCollectionView.h"
@interface FWClassifyTypeVC ()
@property (strong, nonatomic)LhkhCollectionView *faceCollectionView;
@end

@implementation FWClassifyTypeVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFaceCollectionView];
}


#pragma mark - Layout SubViews




#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setFaceCollectionView
{
    [self.view addSubview:self.faceCollectionView];
    [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NavigationBar_H +80);
        make.bottom.equalTo(self.view).offset(-TabBar_H );
    }];
}


#pragma mark - Setters

- (LhkhCollectionView*)faceCollectionView
{
    if (_faceCollectionView == nil) {
        _faceCollectionView = [[LhkhCollectionView alloc] initWithFrame:CGRectZero vcType:self.titleType selectType:4];
    }
    return _faceCollectionView;
}


#pragma mark - Getters




@end
