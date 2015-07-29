//
//  ShowTempView.m
//  VoucherCollection
//
//  Created by yongzhang on 15-1-6.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "ShowTempView.h"
#import "UIImageView+Scale.h"
#import "UploadPicPathDao.h"
@interface ShowTempView()
{
    UIView *_bgView ;
    UIScrollView *_scrollView;
    UILabel *_totalLabel;
}
@end

@implementation ShowTempView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = COLOR4(150, 150, 150, 0.5);
        [self initializeApperance];
    }
    return self;
}

- (void)initializeApperance
{

    
    //一个白色背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.65 * SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - SCREEN_HEIGHT * 0.65)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    //未分组Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 25)];
    label.text = @"未分组";
    [_bgView addSubview:label];
    
    //一条分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = COLOR4(200, 200, 200, 1);
    [_bgView addSubview:lineView];
    
    //放图片的滚动视图
    _scrollView = [[UIScrollView alloc] initForAutoLayout];
    [_bgView addSubview:_scrollView];
    [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    [_scrollView autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];
    [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    //添加一个收起按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 65, 55);
    button.center = CGPointMake(SCREEN_WIDTH - 23,0.68 * SCREEN_HEIGHT);
    [button addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, 25, 15);
    imageView.center = CGPointMake(SCREEN_WIDTH - 33,0.68 * SCREEN_HEIGHT);
    imageView.image = [UIImage imageNamed:@"icon_x.png"];
    [self addSubview:imageView];
    
    _totalLabel = nil;
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 60, 25)];
    _totalLabel.font = [UIFont systemFontOfSize:13];
    _totalLabel.textColor = COLOR4(100, 100, 100, 1);
    [_bgView addSubview:_totalLabel];
}

- (void)setImages:(NSArray *)images
{
    _totalLabel.text = [NSString stringWithFormat:@"共%ld张",(unsigned long)images.count];

    for(UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }

    
    _images = images;
    for (int i = 0; i < images.count; i ++) {
        CGFloat positionX = i * SCREEN_WIDTH / 5 + SCREEN_WIDTH / 5 / 2;
        CGFloat positionY = 40 ;
        UIImageView *imageView = [[UIImageView alloc ] init];
        imageView.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 5 - 10, SCREEN_WIDTH / 5 - 10);
        imageView.center = CGPointMake(positionX, positionY);
        [imageView setImage:[UIImageView scale:images[i] toSize:imageView.bounds.size]];
        imageView.tag = 21 + i;
        [_scrollView addSubview:imageView];
        
        //长按手势
        imageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed:)];
        [imageView addGestureRecognizer:longPressed];
        
        //短按手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singlePressed:)];
        [imageView addGestureRecognizer:tapGesture];
        
        //已上传提示
        UILabel *uploadLabel = [[UILabel alloc] initForAutoLayout];
        uploadLabel.text = @"已上传";
        uploadLabel.font = [UIFont systemFontOfSize:13];
        uploadLabel.textColor = COLOR4(150, 150, 150, 1);
        uploadLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:uploadLabel];
        [uploadLabel autoSetDimensionsToSize:CGSizeMake(60, 21)];
        [uploadLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:5];
        [uploadLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:imageView];
        
        NSString *path = _imagePaths[i];
        BOOL has = [UploadPicPathDao hasDataWithPath:path];
        if(!has) {
            uploadLabel.hidden = YES;
        }
    }
    //计算偏移量的高
    CGFloat contentWidth = SCREEN_WIDTH / 5 * _images.count;
    _scrollView.contentSize = CGSizeMake(contentWidth, 0);
}

//收起视图
- (void)hideSelf
{
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 1.5);
        
    }];
}

- (void)buttonPressed:(UILongPressGestureRecognizer *)gesture
{
    NSInteger index = gesture.view.tag - 21;
    NSString *path = _imagePaths[index];
    if( _delegate && [_delegate respondsToSelector:@selector(backLongPressedPath:)]) {
        [_delegate backLongPressedPath:path];
    }
}

- (void)singlePressed:(UITapGestureRecognizer *)gesture
{
    NSInteger index = gesture.view.tag - 21;
    if(_delegate && [_delegate respondsToSelector:@selector(backSingeleIndex:)]) {
        [_delegate backSingeleIndex:index];
    }

}


@end
