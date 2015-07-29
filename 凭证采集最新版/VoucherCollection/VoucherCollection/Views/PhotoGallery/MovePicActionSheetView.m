//
//  MovePicActionSheetView.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-28.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "MovePicActionSheetView.h"
#import "EntityOneDao.h"
#import "IPInfos.h"
#import "SelectState.h"
#import "CompanyDao.h"
#import "Company.h"
#import "TimeLocalDao.h"
#import "TimeLocal.h"
#import "DetailLocal.h"
#import "DetailLocalDao.h"
#import "CostDetailInfo.h"

@interface MovePicActionSheetView()<UIActionSheetDelegate>
{
    SelectState *_state ;
    NSString *_ip;
    NSString *_chooseCompany;
    NSNumber *_dwid;
    NSString *_companyTime;
    NSNumber *_ndid;
    NSString *_dbID;
    
    NSString *_taskDetail;
    NSString *_thing;
    NSString *_takeMoney;
    NSNumber *_iden;
    
    
    NSArray *_ipInfos;//ip数组信息
    NSArray *_companys;
    NSArray *_times;
    NSMutableArray *_tasks;
}
@end

@implementation MovePicActionSheetView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _state = [SelectState shareInstance];
    }
    return self;
}

- (void)start
{
    //第一层 ip地址
    _ipInfos = [EntityOneDao readObjectWithEntityName:@"IPInfos" predicate:nil];
    if(_ipInfos.count == 0) {
        [self showAlert];
        [self removeFromSuperview];

        return;
    }
    
    if(_fromDetail) {
        _ip = _state.nowIp;
        _chooseCompany = _state.companyName;
        _companyTime = _state.companyTime;
        _ndid = _state.ndid;
        _dwid = _state.dwid;
        _dbID = _state.sdbGuid;
        [self choosetask];
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"移动图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for(IPInfos *ipInfo in _ipInfos) {
        [sheet addButtonWithTitle:ipInfo.ipAddress];
    }
    sheet.tag = 41;
    [sheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self removeFromSuperview];
        return;
    }
    
    switch (actionSheet.tag) {
        case 41:{
            IPInfos *ipInfo = _ipInfos[buttonIndex - 1];
            _ip = ipInfo.ipAddress;
            [self chooseCompany];
            break;
        }
        case 42:{
            Company *company = _companys[buttonIndex - 1];
            _chooseCompany = company.xmmc;
            _dwid = company.dwid;
            [self chooseTime];
            break;
        }
        case 43: {
            TimeLocal *info = _times[buttonIndex - 1];
            NSString *time = [NSString stringWithFormat:@"%@年%@月-%@月",info.kjYear1,info.kjMonth1,info.kjMonth2];
            _companyTime = time;
            _ndid = info.ndId;
            [self choosetask];
            [self removeFromSuperview];
            break;
        }
        case 44: {
            [self saveStatus:buttonIndex - 1];
            if(_delegate && [_delegate respondsToSelector:@selector(overChoose)]) {
                [_delegate overChoose];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)chooseCompany
{
//    _companys = [CompanyDao readDataWith:_ip];
    if(_companys.count == 0) {
        [self showAlert];
        [self removeFromSuperview];

        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"移动图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for(Company *company in _companys) {
        [sheet addButtonWithTitle:company.xmmc];
    }
    sheet.tag = 42;
    [sheet showInView:self];
    
}

- (void)chooseTime
{
    _times = [TimeLocalDao readDataWith:_ip company:_chooseCompany];
    if(_times.count == 0) {
        [self showAlert];
        [self removeFromSuperview];

        return;
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"移动图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for(TimeLocal *info in _times) {
          NSString *time = [NSString stringWithFormat:@"%@年%@月-%@月",info.kjYear1,info.kjMonth1,info.kjMonth2];
        [sheet addButtonWithTitle:time];
    }
    sheet.tag = 43;
    [sheet showInView:self];
    
}

- (void)choosetask
{
    _tasks = [NSMutableArray new];
    NSArray *array = [DetailLocalDao readDataWith:_ip company:_chooseCompany ndId:_ndid dbID:_dbID fetch:0 limit:NSIntegerMax];
    if(array.count == 0) {
        [self showAlert];
        [self removeFromSuperview];
        return;
    }

    for(DetailLocal *detaiLocal in array) {
        CostDetailInfo *info = [CostDetailInfo new];
        info.bh = detaiLocal.bh;
        info.cyfaname = detaiLocal.cyfaname;
        info.dffse = detaiLocal.dffse;
        info.fjstatus = detaiLocal.fjstatus;
        info.iden = detaiLocal.iden;
        info.jffse = detaiLocal.jffse;
        info.jzsj = detaiLocal.jzsj;
        info.kjmonth = detaiLocal.kjmonth;
        info.kjyear = detaiLocal.kjyear;
        info.pzbh = detaiLocal.pzbh;
        info.pzzl = detaiLocal.pzzl;
        info.sm = detaiLocal.sm;
        [_tasks addObject:info];
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"移动图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for(CostDetailInfo *info in _tasks) {
        NSString *title = [NSString stringWithFormat:@"%@ %@%@",info.jzsj,info.pzzl,info.pzbh];
        [sheet addButtonWithTitle:title];
    }
    sheet.tag = 44;
    [sheet showInView:self];
}

- (void)showAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缺少数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)saveStatus:(NSInteger)index
{
    
    CostDetailInfo *info = _tasks[index];
    _state.iden = info.iden;
    _state.taskDetail = [NSString stringWithFormat:@"%@ %@%@",info.jzsj,info.pzzl,info.pzbh];
    char c = [info.dffse characterAtIndex:0];
    NSString *thing ;
    if(c == 48) {
        thing = [NSString stringWithFormat:@"贷:%@",info.jffse];
    } else {
        thing = [NSString stringWithFormat:@"借:%@",info.dffse];
    }
    _state.thing = thing;
    _state.takeMoney = info.sm;
    _state.ipAddress = _ip;
    _state.companyName = _chooseCompany;
    _state.companyTime = _companyTime;
    _state.dwid = _dwid;
    _state.ndid = _ndid;
    [self removeFromSuperview];
    
}

@end
