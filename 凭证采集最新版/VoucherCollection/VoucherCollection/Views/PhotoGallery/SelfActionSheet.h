//
//  SelfActionSheet.h
//  VoucherCollection
//
//  Created by yongzhang on 15-1-5.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfActionSheet : UIActionSheet

@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,assign) NSInteger hasShowCount;//已经展示的数目

@end
