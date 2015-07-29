//
//  HomeController.h
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "NetBaseController.h"

@interface HomeController : NetBaseController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) IBOutlet UIView *topView;
@property (nonatomic,assign) BOOL isInWifi;
@property (nonatomic,strong)NSString *searchStr;


@end
