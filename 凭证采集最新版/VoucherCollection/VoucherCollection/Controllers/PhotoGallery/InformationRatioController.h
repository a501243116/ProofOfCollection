//
//  InformationRatioController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "BaseController.h"
#import "Photos.h"
#import "AdScrollView.h"

@interface InformationRatioController : BaseController

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (nonatomic,strong) Photos *photo;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,assign) NSInteger selectedIndex;//拍选中的iden所在数组下标
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,assign) BOOL fromHome;//从主页进入

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@end
