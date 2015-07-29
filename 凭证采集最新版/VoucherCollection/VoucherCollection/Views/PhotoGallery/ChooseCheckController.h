//
//  ChooseCheckController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGParentController.h"

@interface ChooseCheckController : PGParentController

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *imagesAndPathArray;
@property (nonatomic,strong) NSMutableArray *imagesArray;
@property (nonatomic,strong) NSString *companyTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;

@property (assign,nonatomic) BOOL isTemp;

@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *ipAddress;

- (IBAction)deleteImg:(UIButton *)sender;

- (IBAction)upload:(id)sender;

@end
