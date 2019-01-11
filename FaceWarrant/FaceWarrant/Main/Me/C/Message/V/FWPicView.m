//
//  FWPicView.m
//  FaceWarrant
//
//  Created by FW on 2018/9/7.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWPicView.h"
#import "FWWarrantDetailVC.h"
#import "FWQAndADetailModel.h"
@interface FWPicView()
@property (nonatomic,strong)NSMutableArray *picArr;
@property (nonatomic,strong)NSMutableArray *cuspicArr;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation FWPicView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response
-(void)tap:(UITapGestureRecognizer *)tap
{
    self.cuspicArr = [ReleaseGoodsDtoListModel mj_objectArrayWithKeyValuesArray:self.picArr];
    ReleaseGoodsDtoListModel *model = self.cuspicArr[tap.view.tag];
    FWWarrantDetailVC *vc = [FWWarrantDetailVC new];
    vc.releaseGoodsId = model.releaseGoodsId;
    [[self superViewController:self].navigationController pushViewController:vc animated:YES];
}

#pragma mark - Network Requests


#pragma mark - Public Methods

- (void)configViewWithPicArr:(NSArray*)picArray;
{
    [self.picArr removeAllObjects];
    [self.picArr addObjectsFromArray:picArray];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(self.picArr.count > 0)
    {
        float heightAndWidth = (Screen_W - 90)/3;
        [self.picArr enumerateObjectsUsingBlock:^(NSDictionary *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.frame = CGRectMake((idx%3) * (heightAndWidth+10), (idx/3)* (heightAndWidth+10), heightAndWidth, heightAndWidth);
            [imageView sd_setImageWithURL:URL(imageName[@"modelUrl"]) placeholderImage:[UIImage imageNamed:@"3"]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.tag = idx;
            [self addSubview:imageView];
            [self.cuspicArr addObject:imageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imageView addGestureRecognizer:tap];
        }];
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
- (NSMutableArray*)cuspicArr
{
    if (_cuspicArr == nil) {
        _cuspicArr = [NSMutableArray array];
    }
    return _cuspicArr;
}

- (NSMutableArray*)picArr
{
    if (_picArr == nil) {
        _picArr = [NSMutableArray array];
    }
    return _picArr;
}

#pragma mark - Getters



@end
