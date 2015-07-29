//
//  TakePhotoController.m
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "TakePhotoController.h"
#import "SelectState.h"
#import "IPInfoDao.h"
#import "IPInfos.h"
#import "PhotoController.h"
#import "PhotosDao.h"
#import "TokePhoneAlertView.h"

@interface TakePhotoController ()<UIAlertViewDelegate,PhotoControllerDelegate>
{
    BOOL _fromLast;
    BOOL _toTemp;
}

@end

@implementation TakePhotoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.leftBarButtonItem = nil;
//    SelectState *selectState = [SelectState shareInstance];
    
    self.title = @"拍照";
    self.navigationItem.rightBarButtonItem = nil;
    
    if(_fromLast == YES) {
        return;
    }


        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否进入拍照" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"自由拍照", nil];
        [alertView show];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    [self initializeDataSource];
    [self initializeApperance];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        return;
    }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PhotoController *controller = [storyboard instantiateViewControllerWithIdentifier:@"photo"];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            controller.delegate = self;
            controller.hasSingleToLocTem = YES;
 
}

- (void)backController:(NSInteger)index
{
    _fromLast = YES;
    self.tabBarController.selectedIndex = index;
    [self performSelector:@selector(change:) withObject:[NSNumber numberWithInteger:index] afterDelay:1];
}

- (void)change:(NSNumber *)index;
{
    _fromLast = NO;

}



@end
