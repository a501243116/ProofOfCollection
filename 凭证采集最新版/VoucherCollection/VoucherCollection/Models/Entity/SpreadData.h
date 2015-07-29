//
//  SpreadData.h
//  TestThreeAgreeTableView
//
//  Created by yongzhang on 15-1-27.
//  Copyright (c) 2015年 yongzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpreadClass.h"

@interface SpreadData : NSObject

@property (nonatomic,assign) NSInteger section;
@property (nonatomic,strong) NSMutableArray *postions;

- (id)initWithSpreedClass:(SpreadClass *)sc section:(NSInteger)section;
- (NSDictionary *)backPostionWithIndex:(NSInteger)index;


@end
