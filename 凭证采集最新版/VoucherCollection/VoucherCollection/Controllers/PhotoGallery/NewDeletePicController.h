//
//  NewDeletePicController.h
//  VoucherCollection
//
//  Created by yongzhang on 15-1-21.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface NewDeletePicController : BaseController

@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *paths;
@property (nonatomic,assign) NSInteger nowIndex;
@property (nonatomic,assign) BOOL fromTemp;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic,strong) NSNumber *iden;

@end
