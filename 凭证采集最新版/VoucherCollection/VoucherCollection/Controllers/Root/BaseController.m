//
//  ViewController.m
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()<UITextFieldDelegate>
{
    UIAlertView *_alertView;
}

- (void)initializeApperance;


@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    _selectState = [SelectState shareInstance];
        
    _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
}

- (void)showAlertWithMessage:(NSString *)message
{
    if(_alertView.hidden) {
        return;
    }
    _alertView.message = message;
    [_alertView show];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _alertView.hidden = YES;
    
}

- (void)initializeApperance
{
}

- (void)initializeDataSource
{
    
}

/*
 自定义返回按钮
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _alertView.hidden = NO;

//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"general_nav_64.png"] forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;

    NSDictionary *titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.bounds = CGRectMake(0, 0, 45, 45);
    [returnButton setImage:[UIImage imageNamed:@"icon_fh_n.png"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(backLastController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    self.navigationItem.leftBarButtonItem = item;    
}

- (void)backLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
