//
//  ChooseController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-13.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "BaseController.h"

@protocol ChooseControllerDelegate <NSObject>

//返回筛选的数据给上一个controller
- (void)backController;

@end

@interface ChooseController : BaseController

@property (assign,nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UIButton *allButton;

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIView *leftView;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITableView *tableView1;
- (IBAction)selectAll:(id)sender;

@end
