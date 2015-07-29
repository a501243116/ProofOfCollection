//
//  ChooseCheckCell.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "ChooseCheckCell.h"
#import "UploadPicPathDao.h"
#import "UIImageView+Scale.h"

@implementation ChooseCheckCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _selectedImages = [NSMutableArray new];
        _selectedPaths = [NSMutableArray new];
        [self initializeApperance];
    }
    return self;
}

- (void)initializeApperance
{
    _mainView = [[UIView alloc] init];
    [self.contentView addSubview:_mainView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = COLOR4(220, 220, 220, 1);
    [self.contentView addSubview:lineView1];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 150, 30)];
    [self.contentView addSubview:_titleLabel];
    
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
    [_selectedImages removeAllObjects];
    [_selectedPaths removeAllObjects];
    _images = images;
    NSInteger num = images.count;
    CGFloat height =  60 + (num / 5 + 1) * (SCREEN_WIDTH / 5 + 20);
    _mainView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, height);
    _mainView.center = CGPointMake(SCREEN_WIDTH / 2, height / 2);

    for(UIView *view in _mainView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < images.count; i ++) {
        CGFloat positionX = i % 5 * SCREEN_WIDTH / 5 + SCREEN_WIDTH / 5 / 2 + 8;
        CGFloat positionY = i / 5 * (SCREEN_WIDTH / 5 + 20)+ SCREEN_WIDTH / 5 / 2 + 60;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, SCREEN_WIDTH / 5 - 10, SCREEN_WIDTH / 5 - 10);
        button.center = CGPointMake(positionX, positionY);
        UIImage *image = images[i];
        [button setImage:[UIImageView scale:images[i] toSize:image.size] forState:UIControlStateNormal];
        button.backgroundColor = COLOR4(200, 200, 200, 0.8);
        button.tag = 21 + i;
        [_mainView addSubview:button];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //button右下角添加蓝色的勾
        CGFloat positionX1 = positionX + (SCREEN_WIDTH / 5 - 10) / 2 - 20;
        CGFloat positionY2 = positionY + (SCREEN_WIDTH / 5 - 10) / 2 - 20;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(positionX1, positionY2, 25, 20)];
        imageView.image = [UIImage imageNamed:@"icon_xzk_n.png"];
        imageView.tag = 2021 + i;
        [_mainView addSubview:imageView];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(positionX1, positionY2 + 5, 20, 20)];
        imageView2.image = [UIImage imageNamed:@"icon_xzk_p.png"];
        imageView2.tag  = 1021 + i;
        imageView2.hidden = YES;
        [_mainView addSubview:imageView2];
        
        //已上传提示
        UILabel *uploadLabel = [[UILabel alloc] initForAutoLayout];
        uploadLabel.text = @"已上传";
        uploadLabel.font = [UIFont systemFontOfSize:13];
        uploadLabel.textColor = COLOR4(150, 150, 150, 1);
        uploadLabel.textAlignment = NSTextAlignmentCenter;
        [_mainView addSubview:uploadLabel];
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

- (void)buttonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    UIImageView *imageView = (UIImageView *)[_mainView viewWithTag:sender.tag + 1000];
    UIButton *button = (UIButton *)[_mainView viewWithTag:sender.tag];
    if(sender.selected) {
        imageView.hidden = NO;
        [_selectedImages addObject:button.imageView.image];
        [_selectedPaths addObject:_paths[sender.tag - 21]];
        
    } else {
        imageView.hidden = YES;
        [_selectedImages removeObject:button.imageView.image];
        NSString *str = _paths[sender.tag - 21];
        [_selectedPaths removeObject:str];
    }
}

- (void)selectedAll
{
    [_selectedImages removeAllObjects];
    [_selectedPaths removeAllObjects];
    for (int i = 0; i < _images.count; i ++) {
        UIImageView *imageView = (UIImageView *)[_mainView viewWithTag:1021 + i];
        UIButton *button = (UIButton *)[_mainView viewWithTag:21 + i];
        [_selectedImages addObject:button.imageView.image];
        [_selectedPaths addObject:_paths[i]];
        imageView.hidden = NO;
        
    }
}

- (void)cancel
{
    [_selectedImages removeAllObjects];
    [_selectedPaths removeAllObjects];
    for (int i = 0; i < _images.count; i ++) {
        UIImageView *imageView = (UIImageView *)[_mainView viewWithTag:1021 + i];
        imageView.hidden = YES;
    }
}

@end
