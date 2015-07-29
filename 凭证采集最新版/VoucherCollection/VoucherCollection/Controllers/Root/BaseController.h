//
//  ViewController.h
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectState.h"

@interface BaseController : UIViewController

@property (nonatomic,strong) NSUserDefaults *defaults;
@property (nonatomic,strong) SelectState *selectState;

- (void)initializeApperance;
- (void)initializeDataSource;
- (void)showAlertWithMessage:(NSString *)message;

@end

