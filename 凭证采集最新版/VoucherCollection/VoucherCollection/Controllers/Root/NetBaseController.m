//
//  NetBaseController.m
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "NetBaseController.h"
#import "InputPwdController.h"

@interface NetBaseController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *_hud;
}

@end

@implementation NetBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    self.netDic = [[NSMutableDictionary alloc] init];


}

- (void)showHUd
{
    //设置网络访问加载一个进度条
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.hidden = NO;
    [self.view addSubview:_hud];
    _hud.delegate = self;
    _hud.labelText = @"Loading";
    [_hud show:YES];
    [_hud hide:YES afterDelay:10];
}

- (void)endMBProgressHud
{
    if(!_hud.hidden) {
        _hud.hidden = YES;
         [_hud hide:YES];
    } else {
        
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
}

- (void)netTask:(NSString *)urlStr
{
    [self showHUd];
    [self.netDic setValue:NETKEY forKey:@"key"];
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    NSString *rootUrl = [userDefauls stringForKey:@"rootUrl"];
    _url = [NSString stringWithFormat:@"%@%@",rootUrl,urlStr];
}

- (void)VerifyPassword:(void(^)(void))success
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:_ipAdress];
    [self.netDic setValue:@"a2b2755d2be2a70c187d300f14f09d27" forKey:@"key"];
    [self.netDic setValue:pwd forKey:@"passKey"];
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080/pzcj/computerLogin.sht",_ipAdress];
    [self.manager POST:urlStr parameters:self.netDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqual:@0]) {
            InputPwdController *controller = [[InputPwdController alloc] init];
            controller.ipAddress =_ipAdress;
            [self.navigationController pushViewController:controller animated:YES];
        }
        [hud hide:YES];
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertWithMessage:@"网络错误"];
        [hud hide:YES];
    }];
}

@end
