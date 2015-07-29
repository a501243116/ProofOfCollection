//
//  ObDeletePicController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-24.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "ObDeletePicController.h"

@interface ObDeletePicController ()


@end


@implementation ObDeletePicController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(refrehTabelAfterDelete:) name:DELETEPIC_NOT object:nil];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:DELETEPIC_NOT object:nil];
}

- (void)refrehTabelAfterDelete:(NSNotification *)noti
{
    
}

@end
