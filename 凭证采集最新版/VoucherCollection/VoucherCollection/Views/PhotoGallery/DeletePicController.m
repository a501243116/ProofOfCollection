//
//  DeletePicController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-25.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "DeletePicController.h"
#import "ThreeImageView.h"
#import "Photos.h"
#import "TokePhone.h"
#import "PhotosList.h"
#import "PhotosDao.h"


@interface DeletePicController ()<ThreeImageViewDelegate>
{
    ThreeImageView *_imageViews;
    NSMutableArray *_images;
    NSInteger _nowIndex;
    NSInteger _firstIndex;//返回是第几个数组
    NSInteger _secondeIndex;//返回是第几个数组哪一张图片
    NSMutableArray *_titleArray;//标题数组
}

@end

@implementation DeletePicController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 70, 30);
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeApperance];

}

- (void)initializeDataSource
{
    [self setTitleFromDataArray];
    _nowIndex = 0;
    _images = [NSMutableArray new];
    for (int i = 0; i < _imagesArray.count; i ++) {
        NSArray *array = _imagesArray[i];
        for (int j = 0 ; j < array.count; j ++) {
            [_images addObject:array[j]];
        }
    }
}

//从dataAarray中分离出标题
- (void)setTitleFromDataArray
{
    _titleArray = [NSMutableArray new];
    int startIndex = 0;
    if(_hasTemp) {
        [_titleArray addObject:@"未分组"];
        startIndex = 1;
    } else {
    }
    for(int i = startIndex;i < _dataArray.count;i ++) {
        Photos *photo = _dataArray[i];
        [_titleArray addObject:photo.taskDetail];
    }
    
}

- (void)initializeApperance
{
    UIView *view = [self.view viewWithTag:11];
    [view removeFromSuperview];
    
    if(_images.count == 0) {
        _countLabel.text = @"已经全部删除";
        return;
    }
    if(_nowIndex != 0) {
        _nowIndex --;
    }
    
    _imageViews = [[ThreeImageView alloc] initWithImages:_images frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) index:_nowIndex];
    _imageViews.selfDelegate = self;
    _imageViews.tag = 11;
    [self.view addSubview:_imageViews];
    self.title = _titleArray[0];
    
    NSString *str = [NSString stringWithFormat:@"%ld/%lu",(long)_nowIndex + 1,(unsigned long)_images.count];
    _countLabel.text = str;

}

- (void)deleteImg:(UIButton *)sender
{
    if(_pathArray.count == 0) {
        return;
    }
    NSString *path = _pathArray[_firstIndex][_secondeIndex];
    
    NSMutableArray *childArray = _pathArray[_firstIndex];
    [childArray removeObjectAtIndex:_secondeIndex];
    if(childArray.count == 0) {
        [_pathArray removeObject:childArray];
    }
    
    NSMutableArray *imageChildArray = _imagesArray[_firstIndex];
    [imageChildArray removeObjectAtIndex:_secondeIndex];
    if(imageChildArray.count == 0) {
        [_imagesArray removeObject:imageChildArray];
    }
    
    if(_hasTemp) {
        [TokePhone deleteImgWIthFullPath:path];
    } else {
    [TokePhone deleteImgWithPath:path];
    }
    [_images removeObjectAtIndex:_nowIndex];
    
    //判断所在凭证是否所有图片都已经删除
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_imagesArray forKey:@"images"];
    if(childArray.count == 0) {
        [dic setValue:[NSNumber numberWithInteger:_firstIndex] forKey:@"empty"];
        //删除数据库数据
        if(_hasTemp && _firstIndex == 0) {
            
        } else {
        Photos *photo = _dataArray[_firstIndex];
        [PhotosDao deleteByIden:photo.iden];
        }
    }
    
    //    //发送通知
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        NSNotification *not = [[NSNotification alloc] initWithName:DELETEPIC_NOT object:nil userInfo:dic];
        [nc postNotification:not];
    
    
    [self initializeApperance];
    if(_images.count != 0) {
        [self backIndex:_nowIndex];
    };
}

- (void)backIndex:(NSInteger)index
{
    NSString *str = [NSString stringWithFormat:@"%ld/%lu",(long)index + 1,(unsigned long)_images.count];
    _countLabel.text = str;
    [self backPostion:index];
    _nowIndex = index;
   
    self.title = _titleArray[_firstIndex];

}

//返回当前选中图片位置
- (void)backPostion:(NSInteger)index
{
    NSMutableArray *countArray = [NSMutableArray array];
    for(NSArray *array in _imagesArray) {
        [countArray addObject:[NSNumber numberWithInteger:array.count]];
    }
    
    NSInteger total = 0;
    for(int i = 0 ;i < countArray.count; i ++) {
        NSInteger temp = [countArray[i] integerValue];
        total += temp;
        if(index < total) {
            _firstIndex = i;
            _secondeIndex = index - (total - temp);
            break;
        }
    }
}

@end
