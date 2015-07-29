//
//  Define.h
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#ifndef VoucherCollection_Define_h
#define VoucherCollection_Define_h

//屏幕的宽高
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

//颜色
#define COLOR4(_R_,_G_,_B_,_A_) [UIColor colorWithRed:(_R_)/255.0f green:(_G_)/255.0f blue:(_B_)/255.0f alpha:_A_]

//key
#define NETKEY  @"a2b2755d2be2a70c187d300f14f09d27"

#define COMPANDY_URL @"/pzcj/unitList.sht"
#define COMPANYTIME_URL @"/pzcj/unitTimeList.sht"
#define COST_DETAIL_URL @"/pzcj/pzInfoList.sht"
#define EXAMINE_URL @"/pzcj/checkInfo.sht"
#define COMPUTER_NAME_URL @"/pzcj/computerInfo.sht"
#define CHOOSE_COMPANY_URL @"/pzcj/unitAndTimeList.sht"
#define DATABASE_URL @"/pzcj/switchInfo.sht"

//通知
#define CHOOSE_NOT @"choose_not"
#define DELETEPIC_NOT @"deletepic _not"
#define TABBARCHANGE_NOT @"tabbarchange_not"
#define REFRESHSERVER_NOT @"refreshServer_not"

////取消nslog打印
//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d  \t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)


#endif
