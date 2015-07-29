//
//  ChooseTaskController.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "NetBaseController.h"

@protocol ChooseTaskControllerDelegate <NSObject>

- (void)openTitle:(NSString *)title;

@end

@interface ChooseTaskController : NetBaseController
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)add:(id)sender;
@property (strong,nonatomic) NSString *name;

@property (nonatomic , strong) id<ChooseTaskControllerDelegate>delegate;

@end
