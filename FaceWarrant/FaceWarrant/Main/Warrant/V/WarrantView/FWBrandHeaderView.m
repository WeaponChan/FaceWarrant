//
//  FWBrandHeaderView.m
//  FaceWarrant
//
//  Created by Weapon on 2018/11/20.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import "FWBrandHeaderView.h"
#import "FWBrandDetailModel.h"
@interface FWBrandHeaderView()
{
    CGRect myframe;
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@end

@implementation FWBrandHeaderView

#pragma mark - Life Cycle

- (instancetype)initFaceBrandHeaderViewWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"FWBrandHeaderView" owner:self options:nil].firstObject;
        myframe = frame;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    self.frame = myframe;
}

#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)backClick:(id)sender {
    [[self superViewController:self].navigationController popViewControllerAnimated:YES];
}
#pragma mark - Network Requests


#pragma mark - Public Methods
- (void)configCellWithModel:(FWBrandDetailModel*)model
{
    [self.logoImg sd_setImageWithURL:URL(model.brandUrl) placeholderImage:nil];
    [self.bgImg sd_setImageWithURL:URL(model.brandAdvertising) placeholderImage:nil];
    self.descLab.text = model.brandSynopsis;
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


#pragma mark - Getters



@end
