//
//  ChooseCheckController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "ChooseCheckController.h"
#import "ChooseCheckCell.h"
#import "Photos.h"
#import "TokePhone.h"
#import "DeletePicController.h"
#import "UploadPics.h"
#import "SettingPlistHandler.h"
#import "TokePhone.h"
#import "PhotosDao.h"
#import "MBProgressHUD.h"
#import "UploadPicPathDao.h"
#import "SelectState.h"

@interface ChooseCheckController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *_pathsArray;
    MBProgressHUD *_hud;
    NSString *_nowIp;
    NSMutableArray *_tempImages,*_temPaths,*_temUploads,*_temUploadPaths;//未分组图片和图片路劲
    BOOL _needRefresh;
    BOOL _isChooseAll;
}
@end

@implementation ChooseCheckController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = _companyTitle;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 60, 25);
    [button setTitle:@"全选" forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(chooseAll:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [self performSelector:@selector(initializeDataSource) withObject:nil afterDelay:1];
}

- (void)getData
{
    _needRefresh = YES;
    _dataArray = [NSMutableArray new];
    _imagesArray = [NSMutableArray new];
    _imagesAndPathArray = [NSMutableArray new];
    _temUploads= [NSMutableArray new];
    _temUploadPaths = [NSMutableArray new];
    _temPaths = [NSMutableArray new];
    _tempImages = [NSMutableArray new];
    
    //如果显示的是未分组
    
        if(_isTemp) {
            [_dataArray addObject:@"temp"];
            _tempImages = [TokePhone getImagesFromTemp][@"images"];
            _temPaths = [TokePhone getImagesFromTemp][@"paths"];
        } else {
            
            SelectState *selectState = [SelectState shareInstance];//选择的ip
            _nowIp = selectState.nowIp;
            
            
            [_dataArray addObjectsFromArray:[PhotosDao getDataComDbIdWithIp:self.ipAddress company:self.companyName time:self.time ]];
            for(int i = 0;i < _dataArray.count; i ++) {
                Photos *photo = _dataArray[i];
                NSDictionary *imagesDic;
                 imagesDic = [PhotosDao getImagesWithIp:self.ipAddress companyName:self.companyName time:self.time iden:photo.iden ];
                NSArray *images = imagesDic[@"images"];
                [_imagesAndPathArray addObject:imagesDic];
                [_imagesArray addObject:images];
            }
            
            _pathsArray = [NSMutableArray new];
            for(int i = 0;i < _imagesAndPathArray.count; i ++) {
                NSDictionary *dic = _imagesAndPathArray[i];
                NSArray *paths = dic[@"paths"];
                [_pathsArray addObject:paths];
            }
        }
}

- (void)refreshTable
{
    [_tableView reloadData];
    [self initializeApperance];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _needRefresh = YES;
    _isChooseAll = NO;


    _deleteButton.layer.cornerRadius = 5;
    _uploadButton.layer.cornerRadius = 5;
    _tableView.delegate = self;
    _tableView.dataSource = self;

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

    ChooseCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(!cell) {
        cell = [[ChooseCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    if(_isTemp) {
        cell.titleLabel.text = @"未分组";
        NSInteger count = _tempImages.count;
        cell.countLabel.text = [NSString stringWithFormat:@"共%ld张",(long)count];
        cell.imagePaths = _temPaths;
        cell.paths = _temPaths;
        cell.images = _tempImages;
    } else {
    cell.iden = photo.iden;
    cell.paths = _pathsArray[indexPath.row];
    cell.titleLabel.text = photo.taskDetail;
    NSInteger count = ((NSMutableArray *)_imagesArray[indexPath.row]).count;
    cell.countLabel.text = [NSString stringWithFormat:@"共%ld张",(long)count];
    cell.imagePaths = _imagesAndPathArray[indexPath.row][@"paths"];
        if(_needRefresh == YES) {
    cell.images = _imagesArray[indexPath.row];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == _dataArray.count) {
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
    NSInteger num ;
    if(_isTemp) {
        num = _tempImages.count;
    } else {
        NSArray *images = _imagesArray[indexPath.row];
        num = images.count;
    }
  
    return 60 + ((num - 1) / 5 + 1) * (SCREEN_WIDTH / 5 + 20);
}

- (void)chooseAll:(UIButton *)sender
{
    sender.selected = !sender.selected;
    for (int i = 0; i < _dataArray.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ChooseCheckCell *cell = (ChooseCheckCell *)[_tableView cellForRowAtIndexPath:indexPath];
        if(sender.selected) {
            _isChooseAll = YES;
            [cell selectedAll];
        } else {
            _isChooseAll = NO;
            [cell cancel];
        }
    }
}

- (IBAction)deleteImg:(UIButton *)sender {
    if(_isTemp) {
        [self clearTemImgs];
    } else {
        [self clearImgs];

    }
    [self initializeDataSource];

}

//上传图片
- (IBAction)upload:(id)sender {
    if(_hud != nil) {
        [self showAlertWithMessage:@"请等待上传"];
        return;
    }
    [self startHud];
    [self backTempPic];

    if(_isTemp) {
        if(_temUploads .count == 0) {
            [self showAlertWithMessage:@"没有选中任何附件"];
            [self endMBProgressHud];
            return;
        }
        [self uploadTemple:^{
        }];
        return;
    }
    
    __block NSInteger successCount = 0;
    NSInteger totalCount = 0;
    
    for (int i = 0; i < _dataArray.count; i ++) {
        ChooseCheckCell *cell = (ChooseCheckCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(cell.selectedImages.count != 0) {
            totalCount ++;
        }
    }
    if(totalCount == 0) {
        [self showAlertWithMessage:@"没有选中任何附件"];
        [self endMBProgressHud];
    }
    
    for (int i = 0; i < _dataArray.count; i ++) {
        ChooseCheckCell *cell = (ChooseCheckCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(cell.selectedImages.count != 0) {
        [UploadPics uploadPicsWith:cell.iden pictures:cell.selectedImages ip:_nowIp  block:^(NSInteger status) {
            if(status == 1) {
                successCount ++;
            }
            if(successCount == totalCount) {
                [self endMBProgressHud];
                [self showAlertWithMessage:@"上传成功"];
                NSMutableDictionary *dic = [SettingPlistHandler getSettingData];
                if ([dic[@"isClear"] isEqual:@1]) {
                    [self clearImgs];
                } else { //添加上传文件的路劲在数据库
                    [self savePaths];
                }
                [self initializeDataSource];
            }
            if(status == 2) {
                [self endMBProgressHud];
                [self showAlertWithMessage:@"上传失败"];
            }
           
        }];
        }
    }
    
}

- (void)uploadTemple:(void (^)())block
{
    if(_temUploads.count != 0) {
        [UploadPics uploadTemPics:_temUploads block:^(NSInteger status) {
            if(status == 1) {
                NSMutableDictionary *dic = [SettingPlistHandler getSettingData];
                if ([dic[@"isClear"] isEqual:@1]) {
                    [self clearTemImgs];

                } else { //添加上传文件的路劲在数据库
                    [self saveTempPaths];
                }
                [self initializeDataSource];
                [self endMBProgressHud];
                [self showAlertWithMessage:@"上传成功"];
                
            } else if(status == 2) {
                [self endMBProgressHud];
                [self showAlertWithMessage:@"上传失败"];
                return ;
                
            } else
            {
                [self endMBProgressHud];
                [self showAlertWithMessage:@"没有登录任何服务器"];
            }
        }];
    }
}

- (void)savePaths
{
    
    for (int i = 0; i < _dataArray.count; i ++) {
        ChooseCheckCell *cell = (ChooseCheckCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        for(NSString *deletePath in cell.selectedPaths) {
            if([UploadPicPathDao hasDataWithPath:deletePath]) {
                return;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setValue:deletePath forKey:@"path"];
            [dic setValue:[self backSavePath] forKey:@"spId"];
            [EntityOneDao insertObjectWithParameter:dic entityName:@"UploadPicPath"];
        }
        }

}

- (void)backTempPic
{
    ChooseCheckCell *cell = (ChooseCheckCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _temUploads = cell.selectedImages;
    _temUploadPaths = cell.selectedPaths;
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

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
}

- (void)clearImgs
{
    for (int i = 0; i < _dataArray.count; i ++) {
        ChooseCheckCell *cell = (ChooseCheckCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        for(NSString *path in cell.selectedPaths) {
            [TokePhone deleteImgWithPath:path];
        }
        
        if(cell.selectedPaths.count == cell.paths.count) {
            [PhotosDao deleteByIden:cell.iden ipAddress:_nowIp];
        }
    }
    //发送通知
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSNotification *not = [[NSNotification alloc] initWithName:DELETEPIC_NOT object:nil userInfo:nil];
    [nc postNotification:not];
}

- (void)clearTemImgs
{
    [self backTempPic];
    for(NSString *deletePaths in _temUploadPaths) {
        [TokePhone deleteImgWIthFullPath:deletePaths];
    }
}
/*    //判断所在凭证是否所有图片都已经删除
 NSMutableDictionary *dic = [NSMutableDictionary dictionary];
 [dic setValue:_imagesArray forKey:@"images"];
 if(childArray.count == 0) {
 [dic setValue:[NSNumber numberWithInteger:_firstIndex] forKey:@"empty"];
 //删除数据库数据
 Photos *photo = _dataArray[_firstIndex];
 [PhotosDao deleteByIden:photo.iden];
 }
 
 //    //发送通知
 NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
 NSNotification *not = [[NSNotification alloc] initWithName:DELETEPIC_NOT object:nil userInfo:dic];
 [nc postNotification:not];*/


//接受到删除图片的通知,更新
- (void)refrehTabelAfterDelete:(NSNotification *)noti
{
}
@end
