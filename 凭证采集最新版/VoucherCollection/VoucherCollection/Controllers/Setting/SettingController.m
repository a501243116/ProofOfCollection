//
//  SettingController.m
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "SettingController.h"
#import "SettingPlistHandler.h"
#import "MBProgressHUD.h"
#import "SpecialThanksViewController.h"
@interface SettingController ()

@end

@implementation SettingController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationDidEnterBackgroundNotification];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    [self initializeDataSource];
    [self initializeApperance];
    
    //监听进入后台,保存设置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBack:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
}

- (void)initializeApperance
{
    NSDictionary *dic = [SettingPlistHandler getSettingData];
    _slider.value = [dic[@"imgValue"] floatValue];
    _slider.minimumValue = 5;
    _switchOne.on = [dic[@"isClear"] integerValue];
    _switchTwo.on = [dic[@"isShow"] integerValue];
    _switchThree.on = [dic[@"isTurn"] integerValue];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SettingPlistHandler updataSettingData:_slider.value isClearPic:_switchOne.on isShowAlert:_switchTwo.on isTurn:_switchThree.on];
}

- (void)enterBack:(NSNotification *)noti
{
    [SettingPlistHandler updataSettingData:_slider.value isClearPic:_switchOne.on isShowAlert:_switchTwo.on isTurn:_switchThree.on];

}

- (IBAction)sliderChange:(UISlider *)sender {
    [SettingPlistHandler updataSettingData:_slider.value isClearPic:_switchOne.on isShowAlert:_switchTwo.on isTurn:_switchThree.on];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [NSString stringWithFormat:@"图片质量为%d,预计存储%d张图片",(int)sender.value,(int)([self freeDiskSpace] / ((sender.value) / 100 * 10))];
    [hud show:YES];
    [hud hide:YES afterDelay:1];
    NSLog(@"%f",[self freeDiskSpace]);
}

- (CGFloat)freeDiskSpace

{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    return [[fattributes objectForKey:NSFileSystemFreeSize] floatValue] / 1024.0f / 1024.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SpecialThanksViewController"]) {
        SpecialThanksViewController *specialVC = segue.destinationViewController;
        specialVC.hidesBottomBarWhenPushed = YES;
    }
}

@end
