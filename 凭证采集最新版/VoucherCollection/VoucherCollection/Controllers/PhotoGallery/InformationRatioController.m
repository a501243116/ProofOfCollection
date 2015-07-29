//
//  InformationRatioController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "InformationRatioController.h"
#import "CheckStateController.h"

@interface InformationRatioController ()<AdScrollViewDelegate,CheckStateControllerDelegate>
{
    UISegmentedControl *_seg;
    AdScrollView *_showScollView;
    UIView *_rightView;
    CheckStateController *_controller;
}

@end

@implementation InformationRatioController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = @"凭证信息";
}

- (void)dealloc
{
    
}

- (void)initializeDataSource
{
    if(_fromHome) {
        return;
    }
    _photo = _dataArray[_selectedIndex];
    _images = _imageArray[_selectedIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeApperance];
}

- (void)initializeApperance
{
    _titleLabel.text = _photo.taskDetail;
    _contentLabel.text = _photo.takeMoney;
    _moneyLabel.text = _photo.thing;
    
    //选择器
    _seg = [[UISegmentedControl alloc] initForAutoLayout];
    [_topView addSubview:_seg];
    [_seg autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_topView withMultiplier:0.7];
    [_seg autoSetDimension:ALDimensionHeight toSize:35];
    [_seg autoCenterInSuperview];
    [_seg insertSegmentWithTitle:@"信息比对" atIndex:0 animated:YES];
    [_seg insertSegmentWithTitle:@"核对情况" atIndex:1 animated:YES];
    [_seg addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    _seg.selectedSegmentIndex = 0;
//
    //图片展示
    _showScollView = [[AdScrollView alloc] initWithFrame:CGRectMake(10, 0.35 * SCREEN_HEIGHT, SCREEN_WIDTH - 20, SCREEN_HEIGHT * 0.45)];
    _showScollView.images = _images;
    _showScollView.adDelegate = self;
    [self.view addSubview:_showScollView];
//
    _countLabel.text = [NSString stringWithFormat:@"%d/%lu",1,(unsigned long)_images.count];
//
//    //初始化核对情况
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _controller = [storyboard instantiateViewControllerWithIdentifier:@"checkState"];
    _controller.photo = self.photo;
    [self addChildViewController:_controller];
    _controller.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50 );
    _controller.view.center = CGPointMake(_controller.view.center.x, (SCREEN_HEIGHT - 50) / 2 + 50 );
    _controller.delegate = self;
    _controller.fromHome = _fromHome;
    [self.view addSubview:_controller.view];
    _rightView = _controller.view;
    _rightView.hidden = YES;
}

- (void)swipImg:(NSInteger)page
{
    NSString *str = [NSString stringWithFormat:@"%ld/%lu",(long)page,(unsigned long)_images.count];
    _countLabel.text = str;
}

- (void)changeView:(UISegmentedControl *)seg
{
    if(seg.selectedSegmentIndex == 0) {
        _rightView.hidden = YES;
    } else {
        _rightView.hidden = NO;
    }
}

#pragma mark -- CheckControllerDelegate 
//选择全选按钮后加载下一条数据
- (void)clickAll
{
    _selectedIndex ++;
    if(_selectedIndex == _dataArray.count) {
        [self showAlertWithMessage:@"已是当前最后一条凭证"];
        _selectedIndex --;
    } else {
        _showScollView.images = _imageArray[_selectedIndex];
        _photo = _dataArray[_selectedIndex];
        _titleLabel.text = _photo.taskDetail;
        _contentLabel.text = _photo.takeMoney;
        _moneyLabel.text = _photo.thing;
        _countLabel.text = [NSString stringWithFormat:@"%d/%lu",1,(unsigned long)_showScollView.images.count];

        _controller.photo = _photo;
    }
}

@end
