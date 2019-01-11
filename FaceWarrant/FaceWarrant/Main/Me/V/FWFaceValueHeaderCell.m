//
//  FWFaceValueHeaderCell.m
//  FaceWarrantDel
//
//  Created by FW on 2018/10/29.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import "FWFaceValueHeaderCell.h"
#import "FWWithdrawCashVC.h"
#import "FWWithdrawCashNoteVC.h"
#import "WaterRippleView.h"
@interface FWFaceValueHeaderCell ()
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UILabel *faceValueLab;

@property (strong, nonatomic) WaterRippleView *waterView;

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) CAShapeLayer *shapeLayer2;
@property (strong, nonatomic) UIBezierPath *path2;
@end

@implementation FWFaceValueHeaderCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWFaceValueHeaderCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWFaceValueHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWFaceValueHeaderCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Color_MainBg;
        self.backgroundColor = Color_MainBg;
        _displayLink = nil;
        [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [self setSubView];
        
    }
    return self;
}



#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)backClick
{
    [[self superViewController:self].navigationController popViewControllerAnimated:YES];
}

- (void)txClick
{
    [[self superViewController:self].navigationController pushViewController:[FWWithdrawCashVC new] animated:NO];
}

- (void)txjlClick
{
    [[self superViewController:self].navigationController pushViewController:[FWWithdrawCashNoteVC new] animated:NO];
}


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithIndexPath:(NSIndexPath*)indexPath item:(NSString*)item
{
    self.faceValueLab.text = [NSString stringWithFormat:@"%.1f",item.floatValue];
    if (self.faceValueLab.text.length>6) {
        self.faceValueLab.font = systemFont(20);
    }else if (self.faceValueLab.text.length>8){
        self.faceValueLab.font = systemFont(16);
    }else{
        self.faceValueLab.font = systemFont(30);
    }
}

#pragma mark - Private Methods

- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}


- (void)setSubView
{
    self.headView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_headView];
    
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgimageView.image = Image(@"me_faceValuehu");
    [self.headView addSubview:bgimageView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [backBtn setImage:Image(@"back_white") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:backBtn];
    
    UILabel *itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
    itemLab.text = @"我的脸值";
    itemLab.font = systemFont(18);
    itemLab.textColor = Color_White;
    itemLab.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:itemLab];
    
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.72);
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
    
    [bgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.headView);
        make.top.equalTo(self.headView).offset(-1);
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(22);
        make.top.equalTo(self.headView.mas_top).offset(42);
        make.left.equalTo(self.headView).offset(15);
    }];
    
    [itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(20);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.top.equalTo(self.headView).offset(44);
    }];
    
    UIView *boundView = [[UIView alloc] initWithFrame:CGRectZero];
    boundView.backgroundColor = [UIColor colorWithHexString:@"#FF659A"];
    boundView.layer.cornerRadius = Screen_W*0.16;
    boundView.layer.masksToBounds = YES;
    boundView.layer.borderColor = Color_White.CGColor;
    boundView.layer.borderWidth = 1.f;
    [_headView addSubview:boundView];
    
    
    
    
    [boundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(Screen_W*0.32);
        make.top.equalTo(itemLab.mas_bottom).offset(20);
        make.centerX.equalTo(self.headView.mas_centerX);
    }];
    
    
//    _shapeLayer = [CAShapeLayer layer];
//    _shapeLayer.frame = CGRectMake(0, Screen_W*0.32-Screen_W*0.12, Screen_W*0.32, Screen_W*0.12);
//
//    _shapeLayer2 = [CAShapeLayer layer];
//    _shapeLayer2.frame = CGRectMake(0, Screen_W*0.32-Screen_W*0.12, Screen_W*0.32, Screen_W*0.12);
//
//    _shapeLayer.fillColor = [UIColor colorWithRed:242/255.0 green:181/255.0 blue:204/255.0 alpha:0.3].CGColor;
//    _shapeLayer2.fillColor = [UIColor colorWithRed:244/255.0 green:196/255.0 blue:214/255.0 alpha:0.3].CGColor;
//
//    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawPath)];
//    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//
//    [boundView.layer addSublayer:_shapeLayer];
//    [boundView.layer addSublayer:_shapeLayer2];
    [boundView addSubview:self.waterView];
    [boundView addSubview:self.faceValueLab];
    
    [self.faceValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.top.equalTo(boundView).offset(35);
        make.left.right.equalTo(boundView);
    }];
    
    UILabel *curLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [_headView addSubview:curLab];
    curLab.text = @"余额(￥)";
    curLab.font = systemFont(14);
    curLab.textAlignment = NSTextAlignmentCenter;
    curLab.textColor = Color_White;
    
    [curLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(boundView.mas_bottom).offset(5);
        make.centerX.equalTo(boundView);
    }];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectZero];
    btnView.backgroundColor = Color_White;
    btnView.layer.cornerRadius = 5.f;
    btnView.layer.masksToBounds = YES;
    [self.contentView addSubview:btnView];
    
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.16);
        make.width.offset(Screen_W*0.8);
        make.top.equalTo(self.headView.mas_bottom).offset(-Screen_W*0.08);
        make.centerX.equalTo(self.headView.mas_centerX);
    }];
    
    UIButton *txBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [btnView addSubview:txBtn];
    [txBtn setTitle:@"我要提现" forState:UIControlStateNormal];
    [txBtn setImage:Image(@"me_faceValueCash") forState:UIControlStateNormal];
    txBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [txBtn setTitleColor:Color_MainText forState:UIControlStateNormal];
    txBtn.titleLabel.font = systemFont(14);
    [txBtn addTarget:self action:@selector(txClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#C4C4C4"];
    [btnView addSubview:lineView];
    
    UIButton *txjlBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [btnView addSubview:txjlBtn];
    [txjlBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [txjlBtn setImage:Image(@"me_faceValueCashNote") forState:UIControlStateNormal];
    txjlBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [txjlBtn setTitleColor:Color_MainText forState:UIControlStateNormal];
    txjlBtn.titleLabel.font = systemFont(14);
    [txjlBtn addTarget:self action:@selector(txjlClick) forControlEvents:UIControlEventTouchUpInside];
    
    [txBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.16);
        make.width.offset(Screen_W*0.4);
        make.top.equalTo(btnView);
        make.bottom.equalTo(btnView);
        make.left.equalTo(btnView);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.16-20);
        make.width.offset(1);
        make.centerX.equalTo(btnView.mas_centerX);
        make.centerY.equalTo(btnView.mas_centerY);
    }];
    
    [txjlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.16);
        make.width.offset(Screen_W*0.4);
        make.top.equalTo(btnView);
        make.bottom.equalTo(btnView);
        make.right.equalTo(btnView);
    }];
}

- (void)drawPath {
    
    static double i = 0;
    
    CGFloat A = 10.f;//A振幅
    CGFloat k = 0;//y轴偏移
    CGFloat ω = 0.03;//角速度ω变大，则波形在X轴上收缩（波形变紧密）；角速度ω变小，则波形在X轴上延展（波形变稀疏）。不等于0
    CGFloat φ = 0 + i;//初相，x=0时的相位；反映在坐标系上则为图像的左右移动。
    
    //y=Asin(ωx+φ)+k
    _path = [UIBezierPath bezierPath];
    _path2 = [UIBezierPath bezierPath];
    
    [_path moveToPoint:CGPointZero];
    [_path2 moveToPoint:CGPointZero];
    for (int i = 0; i < Screen_W*0.32; i ++) {
        CGFloat x = i;
        CGFloat y = A * sin(ω*x+φ)+k;
        CGFloat y2 = A * cos(ω*x+φ)+k;
        [_path addLineToPoint:CGPointMake(x, y)];
        [_path2 addLineToPoint:CGPointMake(x, y2)];
        
    }
    [_path addLineToPoint:CGPointMake(Screen_W*0.32, -Screen_W*0.32+Screen_W*0.12)];
    [_path addLineToPoint:CGPointMake(0, -Screen_W*0.32+Screen_W*0.12)];
    _path.lineWidth = 1;
    _shapeLayer.path = _path.CGPath;
    
    [_path2 addLineToPoint:CGPointMake(Screen_W*0.32, -Screen_W*0.32+Screen_W*0.12)];
    [_path2 addLineToPoint:CGPointMake(0, -Screen_W*0.32+Screen_W*0.12)];
    _path2.lineWidth = 1;
    _shapeLayer2.path = _path2.CGPath;
    i += 0.1;
    if (i > M_PI * 2) {
        i = 0;//防止i越界
    }
}

#pragma mark - Setters
- (UILabel*)faceValueLab
{
    if (_faceValueLab == nil) {
        _faceValueLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _faceValueLab.textAlignment = NSTextAlignmentCenter;
        _faceValueLab.font = systemFont(30);
        _faceValueLab.textColor = Color_White;
    }
    return _faceValueLab;
}

- (WaterRippleView*)waterView
{
    if (_waterView == nil) {
        _waterView = [[WaterRippleView alloc] initWithFrame:CGRectMake(0, Screen_W*0.32-Screen_W*0.1333, Screen_W*0.32, Screen_W*0.1333)
                                                        mainRippleColor:[UIColor colorWithRed:242/255.0 green:181/255.0 blue:204/255.0 alpha:1]
                                                       minorRippleColor:[UIColor colorWithRed:244/255.0 green:196/255.0 blue:214/255.0 alpha:1]
                                                      mainRippleoffsetX:2.0f
                                                     minorRippleoffsetX:3.2f
                                                            rippleSpeed:3.5f
                                                         ripplePosition:Screen_W*0.1333f
                                                        rippleAmplitude:5.0f];
        _waterView.backgroundColor = [UIColor clearColor];
    }
    return _waterView;
}

#pragma mark - Getters


@end
