//
//  PhotoGalleryController.m
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "PhotoGalleryController.h"
#import "PhotoGalleryCell.h"
#import "PhotosDao.h"
#import "PhotosList.h"
#import "ChoosePhotosController.h"
#import "PhotoDetalController.h"
#import "TokePhone.h"
#import "MovePicActionSheetView.h"
#import "SelectState.h"
#import "SelectState.h"
#import "TokePhone.h"
#import "NoServerView.h"

@interface PhotoGalleryController ()<UITableViewDataSource,UITableViewDelegate,MovePicActionSheetViewDelegate,PhotoGalleryCellDelgate>
{
    NSMutableArray *_dataArray;
    BOOL _hasFree;//是否有自由拍摄的图片
    NSString *_longPicPath;//长按图片的路劲
    NSMutableArray *_companys;
    MovePicActionSheetView *_sheet;
    BOOL _needRefresh;
    NoServerView *_noServerView;//没有图片界面
}
@end

@implementation PhotoGalleryController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.leftBarButtonItem = nil;
    
    self.title = @"图片库";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 60, 25);
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    self.hidesBottomBarWhenPushed = NO;
    
    [self performSelector:@selector(initializeDataSource) withObject:nil afterDelay:0.2];


}


- (void)dealloc
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _hasFree = NO;
    [self initializeApperance];
    _dataArray = [NSMutableArray new];
    _needRefresh = YES;
}

- (void)getData
{
    _needRefresh = YES;
    self.navigationController.title = @"图片库";
    [_companys removeAllObjects];
    [_dataArray removeAllObjects];
    _dataArray = [NSMutableArray new];
    
    
    [_dataArray addObjectsFromArray:[PhotosDao getDataWithListData]];
    PhotosList *photo = [[PhotosList alloc] init];
    photo.companyName = @"未分组";
    //从数据库却得临时照片
    NSArray *images = [TokePhone getImagesFromTemp][@"images"];
    if(images != nil && images.count != 0) {
        photo.images = images;
        photo.imagePaths = [TokePhone getImagesFromTemp][@"paths"];
        [_dataArray addObject:photo];
        _hasFree = YES;
        _companys = [NSMutableArray new];
        for (int i = 0; i < _dataArray.count - 1; i ++) {
            PhotosList *ph = _dataArray[i];
            [_companys addObject:ph.companyName];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_dataArray.count == 0) {
            _noServerView = [[NoServerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_tableView.bounds))];
            _noServerView.tipLabel.text = @"没有照片，请在凭证列表或拍照选项卡中拍摄";
            [self.view addSubview:_noServerView];
        }else
        {
            [_noServerView removeFromSuperview];
            _noServerView = nil;
        }
    });
}

- (void)refreshTable
{
    [_tableView reloadData];
}


//选择按钮点击
- (void)buttonPressed
{
    if(_dataArray.count == 0) {
        [self showAlertWithMessage:@"没有数据"];
        return;
    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChoosePhotosController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"choosePhotos"];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initializeApperance
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _sheet = [MovePicActionSheetView new];
    _sheet.delegate = self;

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
    PhotosList *ph = _dataArray[indexPath.row];

    PhotoGalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(!cell) {
        cell = [[PhotoGalleryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //如果是最后一项,并且有自由拍摄图片
    if (indexPath.row == _dataArray.count - 1 && _hasFree) {
        cell.selfDelegate = self;
        cell.companyLabel.text = ph.companyName;
        
        NSInteger count = ph.images.count;
        cell.countLabel.text = [NSString stringWithFormat:@"共%ld张",(long)count];

            cell.imagePaths = ph.imagePaths;
        if (_needRefresh) {
            cell.images = ph.images;

        }
        [cell addGesture];
    } else {
        cell.companyLabel.text = ph.companyName;
        cell.timeLabel.text = ph.time;
        
        NSInteger count = ph.images.count;
        cell.countLabel.text = [NSString stringWithFormat:@"共%ld张",(long)count];
        
        cell.imagePaths = ph.imagePaths;
        if(_needRefresh) {
        cell.images = ph.images;
        }
        
    }
    if(indexPath.row == _dataArray.count - 1) {
        _needRefresh = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosList *ph = _dataArray[indexPath.row];
    NSInteger num = ph.images.count;
    return 60 + ((num - 1)/ 5 + 1) * (SCREEN_WIDTH / 5 + 20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoDetalController *controller = [storyboard instantiateViewControllerWithIdentifier:@"photoDetail"];
    controller.hidesBottomBarWhenPushed = YES;

    if(indexPath.row == _dataArray.count - 1 && _hasFree) {
        controller.isTemp = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    PhotosList *ph = _dataArray[indexPath.row];
    controller.companyName = ph.companyName;
    controller.time = ph.time;
    controller.ipAddress = ph.ipAddress;
    
    
    //保存选中的ip
    SelectState *selectState = [SelectState shareInstance];
    selectState.nowIp = ph.ipAddress;
    selectState.companyName = ph.companyName;
    selectState.companyTime = ph.time;
    selectState.ndid = ph.ndId;
    selectState.dwid = ph.dwid;
    selectState.sdbGuid = ph.dbID;
    
    [self.navigationController pushViewController:controller animated:YES];

}

//返回长按图片的索引
- (void)backLongPressedIndex:(NSInteger)index
{
//    NSDictionary *dic = [TokePhone getImagesFromTemp];
//    _longPicPath = dic[@"paths"][index];
//    [self showActionSheet];
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
    [TokePhone insertPic:[UIImage imageWithContentsOfFile:_longPicPath]];
    [TokePhone deleteImgWIthFullPath:_longPicPath];
    [self initializeDataSource];
}



@end
