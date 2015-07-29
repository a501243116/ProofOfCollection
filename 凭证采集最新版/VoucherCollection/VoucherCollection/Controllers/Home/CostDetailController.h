//
//  CostDetail.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-13.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "NetBaseController.h"

@interface CostDetailController : NetBaseController

@property (strong,nonatomic) NSString *titleTime;
@property (strong,nonatomic) NSNumber *ndId;
@property (strong,nonatomic) NSNumber *dwid;
@property (strong,nonatomic) NSString *prjName;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
- (IBAction)takePhone:(id)sender;
- (IBAction)filter:(id)sender;
- (IBAction)takePhoneBottom:(id)sender;

@end
