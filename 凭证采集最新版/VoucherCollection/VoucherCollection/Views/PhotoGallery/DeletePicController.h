//
//  DeletePicController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-25.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface DeletePicController : BaseController
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *imagesArray;
@property (nonatomic,strong) NSMutableArray *pathArray;

@property (nonatomic,assign) BOOL hasTemp;//有未分组文件

@end
