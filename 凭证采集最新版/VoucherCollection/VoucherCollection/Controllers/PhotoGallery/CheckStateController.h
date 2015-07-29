//
//  CheckStateController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "BaseController.h"
#import "Photos.h"

@protocol CheckStateControllerDelegate <NSObject>

- (void)clickAll;//点击了全选后回掉协议

@end

@interface CheckStateController : BaseController

- (IBAction)chooseAll:(id)sender;
- (IBAction)clickOne:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) Photos *photo;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) BOOL fromHome;//从主页进入


@end
