//
//  ThreeImageView.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-25.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "ThreeImageView.h"
#import "UIImageView+Scale.h"
@interface ThreeImageView()<UIScrollViewDelegate>
{
    CGFloat _selfWidth;
    CGFloat _selfHeight;
    UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
    NSInteger _nowCenterIndex;
    NSArray *_images;
    UIScrollView *_childScrollVew;//用于战士放大后的图
}

@end

@implementation ThreeImageView

- (id)initWithImages:(NSArray *)images frame:(CGRect)frame index:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if(self) {
        _nowCenterIndex = index;
        _images = images;
        self.delegate = self;
        [self initializeApperance];
    }
    return self;
}

- (void)initializeApperance
{
    if(_images.count == 0) {
        return ;
    }
    
  
    
    _selfWidth = self.frame.size.width;
    _selfHeight = self.frame.size.height;
    
    CGFloat scaleValue = SCREEN_HEIGHT / SCREEN_WIDTH;
    CGFloat width = SCREEN_WIDTH / scaleValue;
    
    //定义三张图
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, width, SCREEN_WIDTH)];
    _leftImageView.center = CGPointMake(_selfWidth * 0.5, _selfHeight / 2);
     _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, SCREEN_WIDTH)];
    _centerImageView.center = CGPointMake(_selfWidth * 1.5, _selfHeight / 2);
     _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, SCREEN_WIDTH)];
    _rightImageView.center = CGPointMake(_selfWidth * 2.5, _selfHeight / 2);
    
    [self addSubview:_leftImageView];
    [self addSubview:_centerImageView];
    [self addSubview:_rightImageView];
    
    _childScrollVew = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -50)];
    _childScrollVew.backgroundColor = [UIColor whiteColor];
    // 创建UIPinchGestureRecognizer手势处理器，该手势处理器激发scaleImage方法
    UITapGestureRecognizer * gestureBack = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(scaleImageBack:)];
    gestureBack.numberOfTapsRequired = 2;
    // 为imageView添加手势处理器
    _childScrollVew.userInteractionEnabled = YES;
    [_childScrollVew addGestureRecognizer:gestureBack];
    
    //设置self
    self.contentSize = CGSizeMake(_selfWidth * 3, 0);
    self.pagingEnabled = YES;
    
    [self changeViewWithIndex:_nowCenterIndex];
    
    // 创建UIPinchGestureRecognizer手势处理器，该手势处理器激发scaleImage方法
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(scaleImage:)];
    gesture.numberOfTapsRequired = 2;
    // 为imageView添加手势处理器
    _centerImageView.userInteractionEnabled = YES;
    [_centerImageView addGestureRecognizer:gesture];
}

- (void)scaleImage:(UITapGestureRecognizer *)gesture
{
    [self addSubview:_childScrollVew];

    CGFloat width = _centerImageView.bounds.size.width * 4;
    CGFloat height = _centerImageView.bounds.size.height * 4;
    _childScrollVew.contentSize = CGSizeMake(width, height);
    _childScrollVew.contentOffset = CGPointMake(width / 2, height / 2);
    UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    bigImageView.image = _centerImageView.image;
    [_childScrollVew addSubview:bigImageView];
    self.scrollEnabled = NO;
}

- (void)scaleImageBack:(UITapGestureRecognizer *)gesture
{
    for(UIView *view in _childScrollVew.subviews) {
        [view removeFromSuperview];
    }
    [_childScrollVew removeFromSuperview];
    self.scrollEnabled = YES;

}

- (void)changeViewWithIndex:(NSInteger)index
{

    NSInteger leftIndex = index - 1;
    if(leftIndex == -1) {
        leftIndex = _images.count - 1;
    }
    
    NSInteger rightIndex = index + 1;
    if(rightIndex == _images.count) {
        rightIndex = 0;
    }
    
    _leftImageView.image = nil;
    _centerImageView.image = nil;
    _rightImageView.image = nil;
    _leftImageView.image = [UIImageView scale:_images[leftIndex] toSize:_leftImageView.bounds.size];
    _centerImageView.image = [UIImageView scale:_images[index] toSize:_leftImageView.bounds.size];
    _rightImageView.image = [UIImageView scale:_images[rightIndex] toSize:_leftImageView.bounds.size];
    self.contentOffset = CGPointMake(_selfWidth, 0);
}

- (void)recoverCenterImageView
{
    CGFloat scaleValue = SCREEN_HEIGHT / SCREEN_WIDTH;
    CGFloat width = SCREEN_WIDTH / scaleValue;
    _centerImageView.bounds = CGRectMake(0, 0, width, SCREEN_WIDTH);
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX == 0) {
        [self recoverCenterImageView];
        _nowCenterIndex = _nowCenterIndex - 1;
        if(_nowCenterIndex == -1) {
            _nowCenterIndex = _images.count - 1;
        }
        [self changeViewWithIndex:_nowCenterIndex];
        if(_selfDelegate && [_selfDelegate respondsToSelector:@selector(backIndex:)]) {
            [_selfDelegate backIndex:_nowCenterIndex];
        }
    }
    if(contentOffsetX == 2*_selfWidth) {
        [self recoverCenterImageView];

        _nowCenterIndex = (_nowCenterIndex + 1) % _images.count;
        [self changeViewWithIndex:_nowCenterIndex];
        if(_selfDelegate && [_selfDelegate respondsToSelector:@selector(backIndex:)]) {
            [_selfDelegate backIndex:_nowCenterIndex];
        }
    }
}

@end
