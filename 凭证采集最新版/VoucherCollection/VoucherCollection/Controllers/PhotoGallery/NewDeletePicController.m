//
//  NewDeletePicController.m
//  VoucherCollection
//
//  Created by yongzhang on 15-1-21.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "NewDeletePicController.h"
#import "ThreeImageView.h"
#import "TokePhone.h"
#import "PhotosDao.h"

@interface NewDeletePicController ()<ThreeImageViewDelegate>
{
    ThreeImageView *_scrollImageViews;
}

@end

@implementation NewDeletePicController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeApperance];
}

- (void)initializeApperance
{
    self.title = _titleStr;
    
    //删除按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 70, 30);
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteImg) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self initializeScrollView];
}

//初始化滚动视图
- (void)initializeScrollView
{
    UIView *view = [self.view viewWithTag:11];
    [view removeFromSuperview];
    view = nil;
    
    if(_images.count == 0) {
        _countLabel.text = @"已经全部删除";
        return;
    }
    
    _scrollImageViews = [[ThreeImageView alloc] initWithImages:_images frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) index:_nowIndex];
    _scrollImageViews.selfDelegate = self;
    _scrollImageViews.tag = 11;
    [self.view addSubview:_scrollImageViews];
    
    NSString *str = [NSString stringWithFormat:@"%ld/%lu",(long)_nowIndex + 1,(unsigned long)_images.count];
    _countLabel.text = str;
}

- (void)deleteImg
{
    if(_images.count == 0) {
        return;
    }
    //移除图片
    NSMutableArray *images = [NSMutableArray arrayWithArray:_images];
    [images removeObjectAtIndex:_nowIndex];
    _images = images;
    
    //取出路劲
    NSString *path = _paths[_nowIndex];
    //删除图片
    if(_fromTemp) {
        [TokePhone deleteImgWIthFullPath:path];
    } else {
    [TokePhone deleteImgWithPath:path];
    }
    
    //移除路劲
    NSMutableArray *paths = [NSMutableArray arrayWithArray:_paths];
    [paths removeObjectAtIndex:_nowIndex];
    _paths = paths;
    
    _nowIndex --;
    if(_nowIndex == -1) {
        _nowIndex = 0;
    }
    [self initializeScrollView];
    
    if(_images.count == 0 && !_fromTemp) {
        NSString *ipAddress = self.selectState.nowIp;
        [PhotosDao deleteByIden:self.iden ipAddress:ipAddress];

    }
  
}

- (void)backIndex:(NSInteger)index
{
    _nowIndex = index;
    NSString *str = [NSString stringWithFormat:@"%ld/%lu",(long)_nowIndex + 1,(unsigned long)_images.count];
    _countLabel.text = str;
}



@end
