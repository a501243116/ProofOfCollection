//
//  SelectState.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-17.
//  Copyright (c) 2014年 zy. All rights reserved.
//

/*用于记录操作顺序的单例*/
#import "IPInfos.h"
#import <Foundation/Foundation.h>

@interface SelectState : NSObject

@property (nonatomic, retain) NSString * ipAddress;//ip地址
@property (nonatomic, retain) NSString * companyName;//公司名字
@property (nonatomic, retain) NSString * companyTime;//公司时间任务
@property (nonatomic, retain) NSString * taskDetail;//详细花费
@property (nonatomic, retain) NSNumber * dwid;//公司id
@property (nonatomic, retain) NSNumber * ndid;//时间id
@property (nonatomic, retain) NSNumber * iden;//花费id
@property (nonatomic, retain) IPInfos *selectIpInfo;
@property (nonatomic,assign) BOOL isInWifi;//是否在wifi访问中
@property (nonatomic, retain) NSString *thing;//做的事情
@property (nonatomic, retain) NSString *takeMoney;//花费的钱

@property (nonatomic, strong) NSString *taskTime;
@property (nonatomic, strong) NSString *taskThing;
@property (nonatomic, strong) NSString *indexTotalStr;

@property (nonatomic, strong) NSString *nowIp;//图片库所用ip

@property (nonatomic, copy) NSString *dbGuid;//网络获得数据库信息
@property (nonatomic, copy) NSString *projectName;

@property (nonatomic, copy) NSString *sdbGuid;//选中的数据库信息
@property (nonatomic, copy) NSString *sprojectName;

+ (id)shareInstance;

@end
