//
//  NetBaseController.h
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "BaseController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NetDataToEntity.h"
#import "CheckServer.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"


@interface NetBaseController : BaseController

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong) NSMutableDictionary *netDic;
@property (nonatomic,strong) NSString *ipAdress;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) MBProgressHUD *hud;


- (void)showHUd;
- (void)endMBProgressHud;
- (void)netTask:(NSString *)urlStr;
- (void)VerifyPassword:(void(^)(void))success;

@end
