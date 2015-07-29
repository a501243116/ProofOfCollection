//
//  AdScrollView.m
//  太平人寿 -张永
//
//  Created by rimi on 14-8-28.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "AdScrollView.h"
#import "UIImageView+Scale.h"

@interface AdScrollView()<UIScrollViewDelegate>
{
    UIScrollView *_scollView;
}

@end

@implementation AdScrollView

- (void)dealloc
{

}

- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        _scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _scollView.pagingEnabled = YES;
        _scollView.delegate = self;
    }
    return self;
}

- (void)setImages:(NSMutableArray *)images
{
    for(UIView *view in _scollView.subviews) {
        [view removeFromSuperview];
    }
    _images = images;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _scollView.contentSize = CGSizeMake(width * images.count, 0);
    _scollView.contentOffset = CGPointMake(0, 0);

    [self addSubview:_scollView];
    for(int i = 0;i < images.count;i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.bounds = CGRectMake(0, 0, width, height);
        [imageView setImage:[UIImageView scale:images[i] toSize:imageView.bounds.size]];
        imageView.center = CGPointMake((0.5 + i) * width, height / 2);
        [_scollView addSubview:imageView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //contentOffset 偏移量
    NSInteger pageNumber = scrollView.contentOffset.x / self.frame.size.width  ;

        if(_adDelegate && [_adDelegate respondsToSelector:@selector(swipImg:)]) {
            [_adDelegate swipImg:pageNumber + 1];
        }
}

@end



















