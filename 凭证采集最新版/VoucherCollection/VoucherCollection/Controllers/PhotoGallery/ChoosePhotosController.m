//
//  ChoosePhotosController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "ChoosePhotosController.h"
#import "PhotosDao.h"
#import "PhotosList.h"
#import "ChoosePhotosController.h"
#import "ChoosePhotoCell.h"
#import "UploadPics.h"
#import "SettingPlistHandler.h"
#import "TokePhone.h"
#import "MBProgressHUD.h"
#import "UploadPicPathDao.h"
#import "DeletePicController.h"
#import "DetailLocalDao.h"
#import "DetailLocal.h"
#import "Photos.h"


@interface ChoosePhotosController ()<UITableViewDataSource,UITableViewDelegate,ChoosePhotoCellDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_deletePaths;
    NSMutableDictionary *_ipDic;
    NSMutableDictionary *_uploadIdenDic;//用于记录删除图片iden和iden下的图片
    MBProgressHUD *_hud;
    NSMutableArray *_tempImages,*_temPaths,*_temUploads,*_temUploadPaths;//未分组图片和图片路劲
    BOOL _isUploading;
    BOOL _needRefresh;
    BOOL _isChooseAll;
}
@end

@implementation ChoosePhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isUploading = NO;
    _needRefresh = YES;
    _isChooseAll = NO;
    [self initializeApperance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = @"图片库";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 60, 25);
    [button setTitle:@"全选" forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(chooseAll:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self performSelector:@selector(initializeDataSource) withObject:nil afterDelay:0.2];
}

- (void)getData
{
    _needRefresh = YES;
    _dataArray = [NSMutableArray new];
    _ipDic = [NSMutableDictionary new];
    _temUploads = [NSMutableArray new];
    _temUploadPaths = [NSMutableArray new];
    
    [_dataArray addObjectsFromArray:[PhotosDao getDataWithListData]];
        for (int i = 0; i < _dataArray.count; i++) { 
            PhotosList *pl = _dataArray[i];
            for(int j = 0; j < pl.idenCountArray.count; j++) {
                NSNumber *countNumber = pl.idenCountArray[j];
                if([countNumber isEqual:@0]) {
                    NSNumber *iden = pl.idenArray[j];
                    NSString *ipAddress = pl.ipAddress;
                    [PhotosDao deleteByIden:iden ipAddress:ipAddress];
                    [self getData];
                    return;
                }
            }
        }
        _deletePaths = [NSMutableArray new];
        _uploadIdenDic = [NSMutableDictionary dictionary];
        
        _tempImages = [TokePhone getImagesFromTemp][@"images"];
        _temPaths = [TokePhone getImagesFromTemp][@"paths"];
        //如果未分组有数据
        if(_temPaths.count != 0) {
            [_dataArray addObject:@"temp"];
        }
}

- (void)refreshTable
{
    [_tableView reloadData];
}



- (void)initializeApperance
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _upButton.layer.cornerRadius = 5;
    _deleteButton.layer.cornerRadius = 5;

}

- (void)chooseAll:(UIButton *)sender
{
    sender.selected = !sender.selected;
    for (int i = 0; i < _dataArray.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ChoosePhotoCell *cell = (ChoosePhotoCell *)[_tableView cellForRowAtIndexPath:indexPath];
        if(sender.selected) {
            [cell selectedAll];
            _isChooseAll = YES;

        } else {
            [cell cancel];
            _isChooseAll = NO;

        }
    }
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
    ChoosePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(!cell) {
        cell = [[ChoosePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    
    
    //如果未分组存在,并且当前cell是最后一列
    if(_temPaths.count != 0 && indexPath.row == _dataArray.count - 1) {
        cell.companyLabel.text = @"未分组";
        cell.imagePaths = _temPaths;
        if(_needRefresh == YES) {
        cell.images = _tempImages;
        }
    }
    else {
        cell.companyLabel.text = ph.companyName;
        cell.timeLabel.text = ph.time;
        
        
        NSInteger count = ph.images.count;
        cell.countLabel.text = [NSString stringWithFormat:@"共%ld张",(long)count];
        
        cell.imagePaths = ph.imagePaths;
        if(_needRefresh == YES) {
        cell.images = ph.images;
        }
    }
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == _dataArray.count - 1) {
        _needRefresh = NO;
    }
    if(_isChooseAll) {
        [cell selectedAll];
    } else {
        [cell cancel];
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_tempImages.count != 0 && indexPath.row == _dataArray.count - 1) {
        NSInteger num = _tempImages.count;
        return 60 + ((num - 1)/ 5 + 1) * (SCREEN_WIDTH / 5 + 20);
    }
    PhotosList *ph = _dataArray[indexPath.row];
    NSInteger num = ph.images.count;
    return 60 + ((num - 1)/ 5 + 1) * (SCREEN_WIDTH / 5 + 20);
}

- (NSString *)backIden:(NSInteger)index picIndex:(NSInteger)picIndex;
{
    PhotosList *pl = _dataArray[index];
    NSInteger total = 0;
     for(int i = 0 ;i < pl.idenCountArray.count; i ++) {
     NSNumber *number = pl.idenCountArray[i];
     NSInteger temp = [number integerValue];
     total += temp;
     if(picIndex < total) {
         return pl.idenArray[i];
     break;
     }
     }
    
    return nil;
}


- (void)startHud
{
    //设置网络访问加载一个进度条
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.hidden = NO;
    [self.view addSubview:_hud];
    _hud.delegate = self;
    _hud.labelText = @"正在上传";
    [_hud show:YES];
    
}

- (void)endMBProgressHud
{
    _hud.hidden = YES;
    [_hud hide:YES];
    _hud = nil;
}

- (void)backCheckImgWithIndex:(NSInteger)index picIndex:(NSInteger)picIndex status:(NSInteger)status
{
    if(_tempImages.count > 0 && index == _dataArray.count - 1) {
    [self backTempImgWithPicIndex:picIndex status:status];
        return;
    }
    
    PhotosList *pl = _dataArray[index];
    NSString *iden = [self backIden:index picIndex:picIndex];//取得iden
    if(status) { //如果是选中图片
        [_deletePaths addObject:pl.imagePaths[picIndex]];
        NSMutableArray *childArray = _uploadIdenDic[iden];
        if (childArray == nil) {
            childArray = [NSMutableArray new];
            _uploadIdenDic[iden] = childArray;
            _ipDic[iden] = pl.ipAddress;
        }
        [childArray addObject:pl.images[picIndex]];
    } else {
        NSString *path = pl.imagePaths[picIndex];
        [_deletePaths removeObject:path];
        
        UIImage *image = pl.images[picIndex];
        NSMutableArray *childArray = _uploadIdenDic[iden];
        [childArray removeObject:image];
    }
}

//判断打勾的是从未分组中勾选的
- (void)backTempImgWithPicIndex:(NSInteger)picIndex status:(NSInteger)status
{
    UIImage *image = _tempImages[picIndex];
    NSString *path = _temPaths[picIndex];
    if(status == 1) {
        [_temUploads addObject:image];
        [_temUploadPaths addObject:path];
    } else {
        [_temUploads removeObject:image];
        [_temUploadPaths removeObject:path];
    }
}

//判断是否勾选公司数据
- (BOOL)backHaveCompanyData
{
    for(NSArray *array in _uploadIdenDic.allValues) {
        if (array.count > 0) {
            return YES;
        }
    }
    
    return NO;
}

- (IBAction)upload:(id)sender {
    if(_hud != nil) {
        [self showAlertWithMessage:@"请等待上传"];
        return;
    }
    if(_temUploads.count == 0 && ![self backHaveCompanyData]) {
        [self showAlertWithMessage:@"没有选择任何凭证"];
        return;
    }
    
    
    [self startHud];
    //先上传未分组
    [self uploadTemple:^{ //如果未分组上传成功
        __block NSInteger count = 0;
        NSInteger totalCount = 0;
        
        if(![self backHaveCompanyData]) {
            [self endMBProgressHud];
            [self showAlertWithMessage:@"上传成功"];
            [self initializeDataSource];
            return ;
        }
        
        for(int i = 0 ;i < _uploadIdenDic.allKeys.count;i ++) {
            NSNumber *iden = _uploadIdenDic.allKeys[i];
            NSArray *pics = _uploadIdenDic[iden];
            if(pics.count != 0) {
                totalCount ++;
            }
        }
   
        
        for(int i = 0 ;i < _uploadIdenDic.allKeys.count;i ++) {
            NSNumber *iden = _uploadIdenDic.allKeys[i];
            NSArray *pics = _uploadIdenDic[iden];
            if(pics.count == 0) {
                continue;
            }
            [UploadPics uploadPicsWith:iden pictures:pics ip:_ipDic[iden] block:^(NSInteger status) {
                if(status == 1) {
                    count ++;
                }
                if(count == totalCount) {
                    [self endMBProgressHud];
                    [self showAlertWithMessage:@"上传成功"];
                    //成功之后,判断是否需要删除本地文件
                    NSMutableDictionary *dic = [SettingPlistHandler getSettingData];
                    if ([dic[@"isClear"] isEqual:@1]) {
                        [self clearImgs];
                    } else { //添加上传文件的路劲在数据库
                        [self savePaths];
                    }
                    [self initializeDataSource];
                    
                } if(status == 2) {
                    [self endMBProgressHud];
                    [self showAlertWithMessage:@"上传失败"];
                }
                
                
            }];
        }

        
    }];
    
    }

- (void)uploadTemple:(void (^)())block
{
    if(_temUploads.count != 0) {
        [UploadPics uploadTemPics:_temUploads block:^(NSInteger status) {
            if(status == 1) {
                NSMutableDictionary *dic = [SettingPlistHandler getSettingData];
                if ([dic[@"isClear"] isEqual:@1]) {
                    [self clearTemImgs];
                    block();
                } else { //添加上传文件的路劲在数据库
                    [self saveTempPaths];
                    block();
                }
            } else {
                [self endMBProgressHud];
                [self showAlertWithMessage:@"上传失败"];
                return ;

            }
        }];
    } else {
        block();
    }
}

- (void)clearTemImgs
{
    for(NSString *deletePaths in _temUploadPaths) {
        [TokePhone deleteImgWIthFullPath:deletePaths];
        
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag != 31) {
        return;
    }
    if(buttonIndex == 1) {
        [self clearTemImgs];
        [self clearImgs];
        [self initializeDataSource];
    }
}



- (IBAction)deletePic:(id)sender {
    NSString *msg = [NSString stringWithFormat:@"确认要将选中的%d张附件删除吗?",_temUploadPaths.count + _deletePaths.count];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    alertView.tag = 31;
}



- (void)clearImgs
{
    for(NSString *path in _deletePaths) {
        [TokePhone deleteImgWithPath:path];
    }

    
}

- (void)savePaths
{
    for(NSString *deletePath in _deletePaths) {
        if([UploadPicPathDao hasDataWithPath:deletePath]) {
            return;
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:deletePath forKey:@"path"];
        [dic setValue:[self backSavePath] forKey:@"spId"];
        [EntityOneDao insertObjectWithParameter:dic entityName:@"UploadPicPath"];
    }
}

- (void)saveTempPaths
{
    for(NSString *deletePath in _temUploadPaths) {
        if([UploadPicPathDao hasDataWithPath:deletePath]) {
            return;
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:deletePath forKey:@"path"];
        [dic setValue:[self backSavePath] forKey:@"spId"];
        [EntityOneDao insertObjectWithParameter:dic entityName:@"UploadPicPath"];
    }
    [self initializeDataSource];
}

//返回上传后没有删除图片的id
- (NSString *)backSavePath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger num = [defaults integerForKey:@"savePath"];
    num ++;
    [defaults setInteger:num forKey:@"savePath"];
    return [NSString stringWithFormat:@"sp%ld",(long)num];
}


@end
