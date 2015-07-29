//
//  CheckCell.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "CheckCell.h"
#import "UIImageView+Scale.h"
#import "UIImage+FKCategory.h"
#import "UploadPicPathDao.h"

@interface CheckCell()<UIScrollViewDelegate>
{
    UIView *_showImgView;
    UIButton *_cancelButton;
    UIImageView *_showImg;
    UIScrollView *_scollView;
    CGFloat _currentScale;
    UIImage *_srcImage;
    
    NSMutableArray *views;
}
@end

@implementation CheckCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        views = [NSMutableArray new] ;
        [self initializeApperance];
    }
    return self;
}

- (void)initializeApperance
{
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = COLOR4(220, 220, 220, 1);
    [self.contentView addSubview:lineView1];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 30)];
    [self.contentView addSubview:_titleLabel];
    
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton.bounds = CGRectMake(0, 0, 80, 35);
    _checkButton.center = CGPointMake(0.65 * SCREEN_WIDTH, 30);
    [_checkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_checkButton setTitle:@"核对" forState:UIControlStateNormal];
    [_checkButton addTarget:self action:@selector(cellCheck:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_checkButton];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.85 * SCREEN_WIDTH, 18,100, 25)];
    _countLabel.font = [UIFont systemFontOfSize:13];
    _countLabel.textColor = COLOR4(150, 150, 150, 1);
    [self.contentView addSubview:_countLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = COLOR4(220, 220, 220, 1);
    [self.contentView addSubview:lineView2];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    for(UIView *view in views) {
        [view removeFromSuperview];
    }
    [views removeAllObjects];
    for (int i = 0; i < images.count; i ++) {
        CGFloat positionX = i % 5 * SCREEN_WIDTH / 5 + SCREEN_WIDTH / 5 / 2 + 8;
        CGFloat positionY = i / 5 * (SCREEN_WIDTH / 5 + 20) + SCREEN_WIDTH / 5 / 2 + 60;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 5 - 10, SCREEN_WIDTH / 5 - 10);
        button.center = CGPointMake(positionX, positionY);
        [button setImage:[UIImageView scale:images[i] toSize:button.bounds.size] forState:UIControlStateNormal];
        button.tag = 21 + i;
        [self.contentView addSubview:button];
        [views addObject:button];
        [button addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
        
        //已上传提示
        UILabel *uploadLabel = [[UILabel alloc] initForAutoLayout];
        uploadLabel.text = @"已上传";
        uploadLabel.font = [UIFont systemFontOfSize:13];
        uploadLabel.textColor = COLOR4(150, 150, 150, 1);
        uploadLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:uploadLabel];
        [views addObject:uploadLabel];
        [uploadLabel autoSetDimensionsToSize:CGSizeMake(60, 21)];
        [uploadLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:button withOffset:5];
        [uploadLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:button];
        
        NSString *path = _imagePaths[i];
        BOOL has = [UploadPicPathDao hasDataWithPath:path];
        if(!has) {
            uploadLabel.hidden = YES;
        }
    }
}

//回掉协议
- (void)cellCheck:(UIButton *)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(check:)]) {
        [_delegate check:sender];
    }
}

- (void)buttonPressed1:(UIButton *)sender
{
    NSInteger index = sender.tag - 21;
    if(_delegate && [_delegate respondsToSelector:@selector(backSelectedPicIndex:title:images:paths:iden:)]) {
        [_delegate backSelectedPicIndex:index title:_titleLabel.text images:_images paths:_imagePaths iden:self.iden];
    }
}

//图片放大显示
- (void)buttonPressed:(UIButton *)sender
{
    NSInteger index = sender.tag - 21;
    UIImage *image = _images[index];
    UIView *window = [[UIApplication sharedApplication].delegate window];
    _currentScale = 1;
    
    [self scaleImg:image];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [window addSubview:_cancelButton];
    [_cancelButton setImage:[UIImage imageNamed:@"icon_sc_n.png"] forState:UIControlStateNormal];
    [_cancelButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [_cancelButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [_cancelButton autoSetDimensionsToSize:CGSizeMake(32, 29)];
    [_cancelButton addTarget:self action:@selector(cancelShow:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scaleImg:(UIImage *)image
{
    UIView *window = [[UIApplication sharedApplication].delegate window];

    _scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scollView.contentSize = _scollView.bounds.size;
    _scollView.backgroundColor = COLOR4(180, 180, 180, 0.7);
    _scollView.contentMode = UIViewContentModeCenter;
    _scollView.delegate = self;
    [window addSubview:_scollView];
    
    CGFloat scaleValue = SCREEN_HEIGHT / SCREEN_WIDTH;
    CGFloat width = SCREEN_WIDTH / scaleValue;
    _showImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, SCREEN_WIDTH)];
    _showImg.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);

    _showImg.image = image;
    _showImg.layer.borderColor = [UIColor grayColor].CGColor;
    _showImg.layer.borderWidth = 1;
    [_scollView addSubview:_showImg];
    
    // 设置imageView允许用户交互，支持多点触碰
    _showImg.userInteractionEnabled = YES;
    _showImg.multipleTouchEnabled = YES;
    // 创建UIPinchGestureRecognizer手势处理器，该手势处理器激发scaleImage方法
    UIPinchGestureRecognizer* gesture = [[UIPinchGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(scaleImage:)];
    // 为imageView添加手势处理器
    [window addGestureRecognizer:gesture];
//
}

- (void) scaleImage:(UIPinchGestureRecognizer*)gesture
{
    CGFloat scale = gesture.scale;
    NSLog(@"%f",scale);

//    // 根据手势处理的缩放比计算图片缩放后的目标大小
    CGSize targetSize = CGSizeMake(_showImg.bounds.size.width * scale ,
                                   _showImg.bounds.size.height * scale);
//    // 对图片进行缩放
    //对太大或者太小进行判断
    CGFloat scaleValue = SCREEN_HEIGHT / SCREEN_WIDTH;
    CGFloat initwidth = SCREEN_WIDTH / scaleValue;
    
    if(targetSize.width < initwidth || targetSize.width > SCREEN_WIDTH * 5) {
        return;
    }
    
    _showImg.bounds = CGRectMake(0, 0, targetSize.width, targetSize.height);
    _scollView.contentSize = _showImg.bounds.size;
    CGFloat width = _showImg.bounds.size.width;
    CGFloat height = _showImg.bounds.size.height;
    CGFloat w,h;
    if(width <= SCREEN_WIDTH) {
        w = SCREEN_WIDTH / 2;
    } else {
        w = width / 2;
    }
    if(height <= SCREEN_HEIGHT) {
        h = SCREEN_HEIGHT / 2;
    } else
    {
        h = height / 2;
    }
//    _scollView.contentOffset = CGPointMake(w, h);
    _showImg.center = CGPointMake(w, h);


}



- (void)check:(UIButton *)sender
{
    
}

- (void)cancelShow:(UIButton *)sender
{
    [_scollView removeFromSuperview];
    [_cancelButton removeFromSuperview];
    [_showImg removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat y = scrollView.contentOffset.y;
    CGFloat xx = _showImg.bounds.size.width - SCREEN_WIDTH;
    CGFloat yy = _showImg.bounds.size.height - SCREEN_HEIGHT;
    if(x <= 0) {
        x = 0;
    } else if (x >= xx) {
        x = xx;
    }
    if(y <= 0) {
        y = 0;
    } else if (y >= yy) {
        y = yy;
    }
    scrollView.contentOffset = CGPointMake(x, y);
}



@end
