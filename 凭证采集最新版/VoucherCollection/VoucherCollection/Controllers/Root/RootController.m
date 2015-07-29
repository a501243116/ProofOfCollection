//
//  RootController.m
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "RootController.h"
#import "BaseController.h"
#import "HomeController.h"

@interface RootController ()<UITabBarControllerDelegate>

- (void)initializeApperance;

@end

@implementation RootController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"服务器";
}


- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:CHOOSE_NOT object:nil];
    [nc removeObserver:self name:TABBARCHANGE_NOT object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeApperance];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(changeController:) name:TABBARCHANGE_NOT object:nil];
}

- (void)initializeApperance
{
    self.delegate = self;
}




- (void)chooseClick:(UIButton *)sender
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSNotification *not = [[NSNotification alloc] initWithName:CHOOSE_NOT object:nil userInfo:nil];
    [nc postNotification:not];
}

- (void)changeController:(NSNotification *)noti
{
    NSNumber *index = noti.userInfo[@"index"];
    self.selectedIndex = [index integerValue];
    self.navigationController.title = @"图片库";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 80, 35);
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    }

@end
