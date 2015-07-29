//
//  PhotoGalleryCell.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-18.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "PhotoGalleryCell.h"
#import "UIImageView+Scale.h"
#import "UploadPicPathDao.h"

@implementation PhotoGalleryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self initializeApperance];
        _imageViews = [NSMutableArray new];
    }
    return self;
}

- (void)initializeApperance
{
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = COLOR4(220, 220, 220, 1);
    [self.contentView addSubview:lineView1];
    
    _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 30)];
    [self.contentView addSubview:_companyLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.65 * SCREEN_WIDTH, 5, 100, 25)];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = COLOR4(150, 150, 150, 1);
    [self.contentView addSubview:_timeLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.65 * SCREEN_WIDTH, 31,100, 25)];
    _countLabel.font = [UIFont systemFontOfSize:13];
    _countLabel.textColor = COLOR4(150, 150, 150, 1);
    _countLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_countLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = COLOR4(220, 220, 220, 1);
    [self.contentView addSubview:lineView2];
}

- (void)setImages:(NSArray *)images
{
    for(UIView *view in _imageViews) {
        [view removeFromSuperview];
    }
    [_imageViews removeAllObjects];

    _images = images;
    for (int i = 0; i < images.count; i ++) {
        CGFloat positionX = i % 5 * SCREEN_WIDTH / 5 + SCREEN_WIDTH / 5 / 2 + 8;
        CGFloat positionY = i / 5 * (SCREEN_WIDTH / 5 + 20) + SCREEN_WIDTH / 5 / 2 + 60;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 5 - 10, SCREEN_WIDTH / 5 - 10);
        imageView.center = CGPointMake(positionX, positionY);
        imageView.image = [UIImageView scale:images[i] toSize:imageView.bounds.size];
        imageView.tag = 30 + i;
        [self.contentView addSubview:imageView];
        [_imageViews addObject:imageView];
        
        //已上传提示
        UILabel *uploadLabel = [[UILabel alloc] initForAutoLayout];
        uploadLabel.text = @"已上传";
        uploadLabel.font = [UIFont systemFontOfSize:13];
        uploadLabel.textColor = COLOR4(150, 150, 150, 1);
        uploadLabel.textAlignment = NSTextAlignmentCenter;
        [_imageViews addObject:uploadLabel];
        [self.contentView addSubview:uploadLabel];
        [uploadLabel autoSetDimensionsToSize:CGSizeMake(60, 21)];
        [uploadLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:5];
        [uploadLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:imageView];
        
        NSString *path = _imagePaths[i];
        BOOL has = [UploadPicPathDao hasDataWithPath:path];
        if(!has) {
            uploadLabel.hidden = YES;
        }
    }
}

//给自由拍摄图片添加手势
- (void)addGesture
{
    for(UIImageView *imageView in _imageViews) {
            UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:gesture];
        }
}

- (void)longPressed:(UILongPressGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)[gesture view];
    NSInteger index = imageView.tag - 30;
    if(_selfDelegate && [_selfDelegate respondsToSelector:@selector(backLongPressedIndex:)]) {
        [_selfDelegate backLongPressedIndex:index];
    }
}

@end
