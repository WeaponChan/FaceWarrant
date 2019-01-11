//
//  FWWarrantInfoImgCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantInfoImgCell.h"
#import "FWWindowManager.h"
@interface FWWarrantInfoImgCell ()

@property(strong, nonatomic)UIImageView *imgView;
@property(nonatomic, strong)UIButton *chaBtn;


@end

@implementation FWWarrantInfoImgCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantInfoImgCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantInfoImgCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantInfoImgCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.chaBtn];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
        
        [self.chaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(30);
            make.right.equalTo(self.contentView).offset(-35);
            make.top.equalTo(self.contentView).offset(20);
        }];
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)deleteClick
{
    
//    if (iOS11Later) {
//        [[self superViewController:self].navigationController popToRootViewControllerAnimated:YES];
//    }else{
//        [[FWWindowManager sharedWindow] showTabbarViewAgain];
//    }
    [[self superViewController:self].navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notif_ChaPop" object:nil];
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 0.5333*Screen_W;
}

- (void)configCellWithData:(UIImage*)image
{
    self.imgView.image = image;
}


#pragma mark - Private Methods

- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

#pragma mark - Setters

- (UIImageView*)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imgView;
}

- (UIButton*)chaBtn
{
    if (_chaBtn == nil) {
        _chaBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chaBtn setBackgroundImage:Image(@"delete") forState:UIControlStateNormal];
        [_chaBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chaBtn;
}

#pragma mark - Getters


@end
