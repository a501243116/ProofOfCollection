//
//  CostDetailAlertController.h
//  VoucherCollection
//
//  Created by yongzhang on 15-2-12.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "BaseController.h"
#import "IdenAlertData.h"
#import "CostDetailInfo.h"

@protocol CosetDetailAlertControllerDelegate <NSObject>

- (void)backLeftOrRightSwipe:(UISwipeGestureRecognizerDirection)direction;

@end

@interface CostDetailAlertController : BaseController

@property (nonatomic, assign) id delegate;

@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IdenAlertData *data;
@property (strong, nonatomic) CostDetailInfo *info;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *kindLabel;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *jfTotal;
@property (strong, nonatomic) IBOutlet UILabel *dfTotal;



@end
