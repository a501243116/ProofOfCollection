//
//  PhotoDetalController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "PhotoDetalController.h"
#import "PhotosDao.h"
#import "CheckCell.h"
#import "Photos.h"
#import "ChooseCheckController.h"
#import "InformationRatioController.h"
#import "TokePhone.h"
#import "ShowTempView.h"
#import "MovePicActionSheetView.h"
#import "NewDeletePicController.h"

@interface PhotoDetalController ()<UITableViewDataSource,UITableViewDelegate,CheckCellDelegate,ShowTempViewDelegate,MovePicActionSheetViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_imagesArray;
    NSMutableArray *_imagesAndPathsArray;
    NSMutableArray *_tempImages,*_tempPaths;
    BOOL _hasFree;
    ShowTempView *_tempView;//底部未分组视图
    NSString *_clickTempImagePath;
      MovePicActionSheetView *_sheet;
    BOOL _needRefresh,_isFirstLoad;
}
@end

@implementation PhotoDetalController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(_isTemp) {
       self.title = @"未分组";
    } else {
        self.title = self.companyName;

    }

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 60, 25);
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [self performSelector:@selector(initializeDataSource) withObject:nil afterDelay:0.2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _needRefresh = YES;
    _isFirstLoad = YES;
    [self initializeApperance];
}

- (void)getData
{
    _needRefresh = YES;
    _dataArray = [NSMutableArray new];
    _imagesArray = [NSMutableArray new];
    _imagesAndPathsArray = [NSMutableArray new];
        //如果点击了未分组进入controller
        if(_isTemp) {
            NSArray *images = [TokePhone getImagesFromTemp][@"images"];
            if(images.count != 0) {
                _hasFree = YES;
                [_dataArray addObject:@"temp"];//再添加一个数据
                [_imagesArray addObject:images];
            }
        } else {
            _tempImages = [TokePhone getImagesFromTemp][@"images"];
            _tempPaths = [TokePhone getImagesFromTemp][@"paths"];
            if(_tempImages != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _tempView.imagePaths = _tempPaths;
                    _tempView.images = _tempImages;
                });
            }
            [_dataArray addObjectsFromArray:[PhotosDao getDataComDbIdWithIp:self.ipAddress company:self.companyName time:self.time ]];
            for(int i = 0;i < _dataArray.count; i ++) {
                Photos *photo = _dataArray[i];
                NSDictionary *imagesDic;
                
                
                imagesDic = [PhotosDao getImagesWithIp:self.ipAddress companyName:self.companyName time:self.time iden:photo.iden ];
                NSArray *images = imagesDic[@"images"];
                [_imagesAndPathsArray addObject:imagesDic];
                [_imagesArray addObject:images];
            }
        }
}

- (void)refreshTable
{
    [_tableView reloadData];
    if(_isFirstLoad) {
        [self initializeApperance];
        _isFirstLoad = NO;
    }
}

- (void)initializeApperance
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //如果是未分组,则隐藏底部未分组视图
    if(_isTemp) {
        _bottomLabel.hidden = YES;
        _bottomButton.hidden = YES;
    } else {
        //添加未分组在底部
        _tempView = [ShowTempView new];
        _tempView.center = CGPointMake(SCREEN_WIDTH / 2, 1.5 * SCREEN_HEIGHT);
        _tempView.tag = 21;
        _tempView.imagePaths = _tempPaths;
        _tempView.images = _tempImages;
        _tempView.delegate = self;
        [self.view addSubview:_tempView];
        
        _sheet = [MovePicActionSheetView new];
        _sheet.fromDetail = YES;
        _sheet.delegate = self;

    }
    
}


- (void)choose:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChooseCheckController *controller = [storyboard instantiateViewControllerWithIdentifier:@"chooseCheck"];
   
    controller.companyTitle = self.title;
    controller.ipAddress = _ipAddress;
    controller.companyName = _companyName;
    controller.time = _time;
    
    //未分组
    if(_isTemp) {
        controller.isTemp = YES;
    }

    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Photos *photo = _dataArray[indexPath.row];

  
    CheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(!cell) {
    cell = [[CheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_hasFree && indexPath.row == _dataArray.count - 1 && _isTemp) {
        NSArray *images = [TokePhone getImagesFromTemp][@"images"];
        cell.checkButton.hidden = YES;
        cell.titleLabel.text = @"未分组";
        NSInteger count = images.count;
        cell.countLabel.text = [NSString stringWithFormat:@"共%ld张",(long)count];
        cell.imagePaths = [TokePhone getImagesFromTemp][@"paths"];
        if(_needRefresh) {
        cell.images = images;
        }
        cell.delegate = self;
        return cell;
    } else {

        cell.titleLabel.text = photo.taskDetail;
        NSInteger count = ((NSMutableArray *)_imagesArray[indexPath.row]).count;
        cell.countLabel.text = [NSString stringWithFormat:@"共%ld张",(long)count];
        cell.imagePaths = _imagesAndPathsArray[indexPath.row][@"paths"];
        cell.iden = photo.iden;
        if(_needRefresh) {
        cell.images = _imagesArray[indexPath.row];
        }
        if([photo.hasSure isEqual:@1]) {
            [cell.checkButton setTitleColor:COLOR4(50, 50, 200, 1) forState:UIControlStateNormal];
        } else {
            [cell.checkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    
      }
    cell.delegate = self;
    if(indexPath.row == _dataArray.count) {
        _needRefresh = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *images = _imagesArray[indexPath.row];
    NSInteger num = images.count;
    return 60 + ((num - 1)/ 5 + 1) * (SCREEN_WIDTH / 5 + 20);
}

- (void)check:(UIButton *)sender
{
    NSIndexPath *indePath;
    if(IS_IOS8) {
    indePath = [_tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    } else {
        indePath = [_tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];

    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InformationRatioController *controller = [storyboard instantiateViewControllerWithIdentifier:@"informationRatio"];

    controller.dataArray = _dataArray;
    controller.imageArray = _imagesArray;
    controller.selectedIndex = indePath.row;
    [self.navigationController pushViewController:controller animated:YES];
}

//返回点击的图片,进入查看,删除
- (void)backSelectedPicIndex:(NSInteger)index title:(NSString *)title images:(NSArray *)images paths:(NSArray *)paths iden:(NSNumber *)iden
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewDeletePicController *controller = [storyboard instantiateViewControllerWithIdentifier:@"deletePic"];
    controller.titleStr = title;
    controller.nowIndex = index;
    controller.images = images;
    controller.paths = paths;
    controller.iden = iden;
    controller.fromTemp = _isTemp;
    [self.navigationController pushViewController:controller animated:YES];
}



//如果进入的是公司不是未分组,则点击显示未分组
- (IBAction)showTemp:(id)sender {
  [UIView animateWithDuration:0.5 animations:^{
      _tempView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
 
      
  }];
}

#pragma mark -- ShowTempViewDelegate
- (void)backLongPressedPath:(NSString *)tempClickPicPath
{
    _clickTempImagePath = tempClickPicPath;
    [self showActionSheet];
    
}

- (void)backSingeleIndex:(NSInteger)index
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewDeletePicController *controller = [storyboard instantiateViewControllerWithIdentifier:@"deletePic"];
    controller.titleStr = @"未分组";
    controller.nowIndex = index;
    controller.paths = [TokePhone getImagesFromTemp][@"paths"];
    controller.images = [TokePhone getImagesFromTemp][@"images"];
    controller.fromTemp = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//得到底部的选择框
- (void)showActionSheet
{
    if ([_sheet superview] != nil) {
        return;
    }
    [self.view addSubview:_sheet];
    [_sheet start];
}

- (void)overChoose
{
    [TokePhone insertPic:[UIImage imageWithContentsOfFile:_clickTempImagePath]];
    [TokePhone deleteImgWIthFullPath:_clickTempImagePath];
    [self initializeDataSource];

}
@end
