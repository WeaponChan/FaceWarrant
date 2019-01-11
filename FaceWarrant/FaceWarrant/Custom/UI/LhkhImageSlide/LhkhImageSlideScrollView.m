//
//  LhkhImageSlideScrollView.m
//  LhkhCommentList
//
//  Created by Lhkh on 2018/6/20.
//  Copyright © 2018年 Lhkh. All rights reserved.
//

#import "LhkhImageSlideScrollView.h"
#import "ItemListImageModel.h"
//#import "UIImage+WebP.h"
#import "UIImageView+WebCache.h"
@interface LhkhImageSlideScrollView()<UIScrollViewDelegate>
@property(nonatomic, strong)NSLayoutConstraint *imageHeightConstraint;
//左后的滑动坐标
@property(nonatomic, assign)CGFloat lastPosition;
//当前页
@property(nonatomic, assign)NSInteger currentpage;
@property(nonatomic, strong)UILabel *pageLab;
@property(nonatomic, strong)NSMutableArray <ItemListImageModel *> *imageArray;
@end

@implementation LhkhImageSlideScrollView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置分页
        self.pagingEnabled = YES;
        //设置弹簧效果为NO
        self.bounces = NO;
        self.delegate = self;
        //关闭自动布局
        self.translatesAutoresizingMaskIntoConstraints = NO;
        //隐藏滚动条
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}


#pragma mark - Layout SubViews




#pragma mark - System Delegate

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //拿到移动中的x
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat currentPostion = offsetX;
    //当前页数
    int page = offsetX / Screen_W;
    
    BOOL isleft;
    if (currentPostion > _lastPosition) {
        isleft = YES;
        if (page > 0  && offsetX - page * Screen_W <0.01) {
            page = page -1;
        }
    }else{
        isleft = NO;
    }
    
    UIImageView *firstImageView = (UIImageView *)[self viewWithTag:100+page];
    UIImageView *nextImageView = (UIImageView *)[self viewWithTag:100+page+1];
    ItemListImageModel *firstModel = [self.imageArray objectAtIndex:page];
    ItemListImageModel *nextModel = [self.imageArray objectAtIndex:page+1];
    
    CGFloat firtstImageHeiht = [self heightformodel:firstModel];
    CGFloat nextImageHeiht = [self heightformodel:nextModel];
    
    //设置Y
    CGFloat distanceY = isleft ? nextImageHeiht - firstImageView.height :firtstImageHeiht - firstImageView.height;
    CGFloat leftDistaceX = (page +1) * Screen_W - _lastPosition;
    CGFloat rightDistanceX = Screen_W - leftDistaceX;
    CGFloat distanceX = isleft ? leftDistaceX :rightDistanceX;
    
    
    //移动值
    CGFloat movingDistance = 0.0;
    if (distanceX != 0 && fabs(_lastPosition - currentPostion) > 0) {
        movingDistance = distanceY / distanceX * (fabs(_lastPosition - currentPostion));
    }
    
    CGFloat firstScale = firstModel.width.floatValue / firstModel.height.floatValue;
    CGFloat nextScale = nextModel.width.floatValue / nextModel.height.floatValue;
    
    
    firstImageView.frame = CGRectMake((firstImageView.frame.origin.x- movingDistance * firstScale), 0, (firstImageView.height+movingDistance)*firstScale, firstImageView.height+movingDistance);
    
    nextImageView.frame = CGRectMake(Screen_W*(page+1), 0, firstImageView.height * nextScale, firstImageView.height);
    //重新设置大小
    self.contentSize = CGSizeMake( Screen_W * self.imageArray.count, firstImageView.height);
    
    //重新设置高度
    CGRect frame = self.frame;
    frame.size.height = firstImageView.height;
    self.frame = frame;
    if ([self.imageslidDelegate respondsToSelector:@selector(LhkhImageSlideScrollViewDelegateWithHeight:)]) {
        [self.imageslidDelegate LhkhImageSlideScrollViewDelegateWithHeight:firstImageView.height];
    }
    
    int newpage = offsetX / Screen_W;
    if ( offsetX - newpage * Screen_W < 0.01) {
        _currentpage = newpage+1;
    }
    self.pageLab.frame = CGRectMake(Screen_W*_currentpage-65, firstImageView.height-35, 65, 20);
    self.pageLab.text = [NSString stringWithFormat:@"%li/%lu",(long)_currentpage,(unsigned long)self.imageArray.count];
    _lastPosition = currentPostion;
}


#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods

- (void)slidingViewWithMMutableArray:(NSMutableArray<ItemListImageModel *> *)imageArray
{
    self.imageArray = imageArray;
    [self initViews];
}


#pragma mark - Private Methods

-(void)initViews{
    CGFloat imageHeight = 0.0f;
    for (NSUInteger i = 0; i < self.imageArray.count ; i++) {
        ItemListImageModel *model = [self.imageArray objectAtIndex:i];
        //获取到宽高比例的高度
        imageHeight = [self heightformodel:model];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_W * i, 0, Screen_W, imageHeight)];
        //多余部分不显示
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 100 +i;
        
//        if ([model.original hasSuffix:@"webp"]) {
//            NSError * error;
//            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.original] options:NSDataReadingMappedIfSafe error:&error];
//            if (data) {
//                UIImage * image = [UIImage sd_imageWithWebPData:data];
//                imageView.image = image;
//            }else{
//                NSLog(@"惨啦，没有拿到数据");
//            }
//        } else {
//            [imageView sd_setImageWithURL:[NSURL URLWithString:model.original] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
//        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.original] placeholderImage:Image_placeHolder100];
        [self addSubview:imageView];
    }
    //获取到第一张图片
    UIImageView *imageView = (UIImageView *)[self viewWithTag:100];
    //设置刚开始的数据
    self.contentSize = CGSizeMake(self.imageArray.count * Screen_W, imageView.height);
    if ([self.imageslidDelegate respondsToSelector:@selector(LhkhImageSlideScrollViewDelegateWithHeight:)]) {
        [self.imageslidDelegate LhkhImageSlideScrollViewDelegateWithHeight:imageView.height];
    }
    
    self.pageLab = [[UILabel alloc] initWithFrame:CGRectMake(Screen_W-65, imageView.height-35, 50, 20)];
    self.pageLab.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.imageArray.count];
    self.pageLab.textColor = [UIColor whiteColor];
    self.pageLab.textAlignment = NSTextAlignmentCenter;
    self.pageLab.font = [UIFont systemFontOfSize:14];
//    [self addSubview:self.pageLab];//显示当前图片页码
    //修改成图片的高度
    CGRect frame = self.frame;
    frame.size.height = imageView.height;
    self.frame = frame;
    
}

- (CGFloat)heightformodel:(ItemListImageModel *)model{
    CGFloat width = Screen_W;
    CGFloat scale = model.width.floatValue / width;
    CGFloat height =  model.height.floatValue / scale;
    return height;
}

#pragma mark - Setters




#pragma mark - Getters



@end
