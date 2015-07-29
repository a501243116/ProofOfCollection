//
//  PhotoDetalController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGParentController.h"
@interface PhotoDetalController : PGParentController

@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *ipAddress;
@property (nonatomic,assign) BOOL isTemp;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) IBOutlet UIButton *bottomButton;


- (IBAction)showTemp:(id)sender;

@end
