//
//  SpreadClass.h
//  TestThreeAgreeTableView
//
//  Created by yongzhang on 15-1-27.
//  Copyright (c) 2015年 yongzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpreadClass : NSObject

@property (nonatomic,assign) BOOL isOPen;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSMutableArray *childArray;

@end
