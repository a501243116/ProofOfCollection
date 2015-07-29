//
//  ChoosePhotosController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-19.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "PGParentController.h"

@interface ChoosePhotosController : PGParentController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *upButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)upload:(id)sender;
- (IBAction)deletePic:(id)sender;

@end
