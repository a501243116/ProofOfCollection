//
//  TaskController.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "NetBaseController.h"
#import "RATreeView.h"
#import "BaseController.h"
#define CONNECTSTATE @"connectState"

@interface TaskController : NetBaseController
//@property (strong , nonatomic) NSString *ipAdress;
//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic) IBOutlet UIButton *addPrjButton;
//- (void)addProject;
//@property (strong, nonatomic) IBOutlet UILabel *nowPrj;
@property (strong, nonatomic) IBOutlet RATreeView *raTreeView;

@end
