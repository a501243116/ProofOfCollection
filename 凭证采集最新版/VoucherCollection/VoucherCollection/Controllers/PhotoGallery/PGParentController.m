//
//  PGParentController.m
//  VoucherCollection
//
//  Created by yongzhang on 15-1-7.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "PGParentController.h"
#import "MBProgressHUD.h"

@interface PGParentController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *_hud;
}

@end

@implementation PGParentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getData
{
    
}

- (void)refreshTable
{
    
}

- (void)initializeDataSource
{
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          dispatch_async(dispatch_get_main_queue(), ^{
              [self showHUd1];
          });
          [self getData];
          dispatch_async(dispatch_get_main_queue(), ^{
              [self endMBProgressHud1];
              [self refreshTable];
          });
      });
}


- (void)showHUd1
{
    //设置网络访问加载一个进度条
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.delegate = self;
    _hud.labelText = @"加载图片";
    [_hud show:YES];
}

- (void)endMBProgressHud1
{
    if(!_hud.hidden) {
        [_hud hide:YES];
    } else {
        
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    _hud = nil;
}

@end
