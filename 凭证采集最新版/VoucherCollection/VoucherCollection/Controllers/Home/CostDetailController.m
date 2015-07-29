//
//  CostDetail.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-13.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "CostDetailController.h"
#import "CostdetailInfo.h"
#import "ChooseController.h"
#import "TokePhone.h"
#import "PhotosDao.h"
#import "DetailLocalDao.h"
#import "DetailLocal.h"
#import "ExamineDao.h"
#import "SelfTPicture.h"
#import "PhotoController.h"
#import "HomePhotoController.h"
#import "TimeLocalDao.h"
#import "CostDetailAlertController.h"
#import "IdenAlertData.h"

@interface CostDetailController ()<UITableViewDataSource,UITableViewDelegate,ChooseControllerDelegate,CosetDetailAlertControllerDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_totalArray;
    BOOL _secondNet;
    NSInteger _nowSelected;
//    CostDetailAlertController *_alertController;
    NSArray *_pzbhArray;
    NSInteger _pzbhIndex;
    NSInteger _page;
    BOOL _isFilter;
    BOOL _isFirstRequest;
    NSMutableArray *_allDataArr;
    CostDetailAlertController *_alertController;
}
@end

@implementation CostDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
 
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.bounds = CGRectMake(0, 0, 60, 30);
    [chooseButton setTitle:@"筛选" forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:chooseButton];
    self.navigationItem.rightBarButtonItem = item;
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //修改公司time中任务数目
    [TimeLocalDao modifyTaskCount:self.selectState.ipAddress company:self.selectState.companyName ndid:self.selectState.ndid count:_totalArray.count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeApperance];
    _page = 0;
    _isFilter = NO;
    _isFirstRequest = YES;
//    __weak id mySelf = self;
//    [_tableView addHeaderWithCallback:^{
//        [mySelf getDataFromNet];
//        
//    }];
    [_tableView addFooterWithTarget:self action:@selector(getDataFromDataSource)];
//    _tableView.headerRefreshingText = @"正在刷新";
    [self getDataFromDataSource];
}

- (void)getDataFromNet
{

    if(!self.selectState.isInWifi) {
        [_tableView headerEndRefreshing];
        [self endMBProgressHud];
        [self showAlertWithMessage:@"没有在WIFI网络中"];
        return;
    }
    [self netTask:COST_DETAIL_URL];//进行详细请求
    [self netTask2:EXAMINE_URL];//进行核对请求
}

//从数据库库取出数据
- (void)getDataFromDataSource
{
    NSArray *array = [DetailLocalDao readDataWith:self.selectState.ipAddress company:self.selectState.companyName ndId:self.selectState.ndid dbID:self.selectState.sdbGuid fetch:_page limit:10];
    _page += array.count;
    if (array.count == 0 && _page == 0 && _isFirstRequest) {
        _isFirstRequest = NO;
        [self getDataFromNet];
    } else {
        for(DetailLocal *detaiLocal in array) {
            CostDetailInfo *info = [CostDetailInfo new];
            info.bh = detaiLocal.bh;//
            info.cyfaname = detaiLocal.cyfaname;
            info.dffse = detaiLocal.dffse;
            info.fjstatus = detaiLocal.fjstatus;
            info.iden = detaiLocal.iden;
            info.jffse = detaiLocal.jffse;
            info.jzsj = detaiLocal.jzsj;//
            info.kjmonth = detaiLocal.kjmonth;
            info.kjyear = detaiLocal.kjyear;
            info.pzbh = detaiLocal.pzbh;//
            info.pzzl = detaiLocal.pzzl;//
            info.sm = detaiLocal.sm;
            info.kmbh = detaiLocal.kmbh;
            NSLog(@"%@",info.bh);
            
            BOOL isSame = NO;
            for(long i = _dataArray.count - 1;i<_dataArray.count;i++)
            {
                NSMutableArray *arr = _dataArray[i];
                for (CostDetailInfo *obj in arr) {
                    if ([obj.jzsj isEqualToString:info.jzsj] && [obj.pzbh integerValue] == [info.pzbh integerValue]) {
                        isSame = YES;
                        break;
                    }
                }
                if (isSame) {
                    [arr addObject:info];
                    break;
                }
            }
            if (isSame == NO) {
                NSMutableArray *temparr = [NSMutableArray arrayWithObject:info];
                [_dataArray addObject:temparr];
            }
            
        }
        if (_isFilter) {
            _dataArray = [TokePhone filter:_dataArray];
        }
        _totalArray = [NSMutableArray arrayWithArray:_dataArray];
        if ([_tableView isFooterRefreshing]) {
            [_tableView reloadData];
            [_tableView footerEndRefreshing];
        }
    }
}

- (void)getAllDataArr
{
    [_allDataArr removeAllObjects];
    _allDataArr = [NSMutableArray array];
    NSArray *array = [DetailLocalDao readAllDataWith:self.selectState.ipAddress company:self.selectState.companyName ndId:self.selectState.ndid dbID:self.selectState.sdbGuid];
    for(DetailLocal *detaiLocal in array) {
        CostDetailInfo *info = [CostDetailInfo new];
        info.bh = detaiLocal.bh;//
        info.cyfaname = detaiLocal.cyfaname;
        info.dffse = detaiLocal.dffse;
        info.fjstatus = detaiLocal.fjstatus;
        info.iden = detaiLocal.iden;
        info.jffse = detaiLocal.jffse;
        info.jzsj = detaiLocal.jzsj;//
        info.kjmonth = detaiLocal.kjmonth;
        info.kjyear = detaiLocal.kjyear;
        info.pzbh = detaiLocal.pzbh;//
        info.pzzl = detaiLocal.pzzl;//
        info.sm = detaiLocal.sm;
        info.kmbh = detaiLocal.kmbh;
        info.kmmc = detaiLocal.kmmc;
        info.isSelected = detaiLocal.isSelected;
        NSLog(@"%@",info.bh);
        [_allDataArr addObject:info];
    }

}

- (void)initializeDataSource
{
    _dataArray = [NSMutableArray new];
    _totalArray = [NSMutableArray new];
    _secondNet = NO;
    _nowSelected = 0;

}

- (void)initializeApperance
{
    self.title = self.titleTime;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.button1.layer.cornerRadius = 5;
    self.button2.layer.cornerRadius = 5;
    

}

//筛选
- (void)choose:(UIBarButtonItem *)item
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChooseController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"choose"];
//    controller.dataArray = _totalArray;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)netTask:(NSString *)urlStr
{
    [super netTask:urlStr];
    [self.netDic setValue:self.ndId forKey:@"ndid"];
    [self.netDic setValue:self.dwid forKey:@"dwid"];
    [self.netDic setValue:self.dwid forKey:@"dwid"];
    [self.netDic setValue:self.ndId forKey:@"ndid"];
    [self.netDic setValue:[[UIDevice currentDevice] systemVersion] forKey:@"phoneVersion"];
    [self.netDic setValue:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"deviceVersion"];
    [self.netDic setValue:[[UIDevice currentDevice] model] forKey:@"phoneModel"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [self.netDic setValue:[infoDictionary objectForKey:@"CFBundleVersion"] forKey:@"softwVersion"];
    [self.netDic setValue:_prjName forKey:@"prjName"];
    [self.manager POST:self.url parameters:self.netDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endMBProgressHud];
        [_tableView headerEndRefreshing];
        [self parseData:responseObject];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endMBProgressHud];
        [_tableView headerEndRefreshing];
        [self showAlertWithMessage:@"网络错误"];
        _isFirstRequest = YES;
    }];
}

- (void)netTask2:(NSString *)urlStr
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.ndId forKey:@"ndid"];
    [dic setValue:self.dwid forKey:@"dwid"];
    [dic setValue:NETKEY forKey:@"key"];

    NSString *rootUrl = [self.defaults stringForKey:@"rootUrl"];
    NSString *url = [NSString stringWithFormat:@"%@%@",rootUrl,urlStr];
    [self.manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseData2:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)parseData2:(NSDictionary *)dic
{
    for(NSDictionary *dicData in dic[@"data"]) {
        [ExamineDao insertDataWithDic:dicData];
        
    }
}

- (void)parseData:(NSDictionary *)responseObject
{
    [_dataArray removeAllObjects];
    [_totalArray removeAllObjects];
    if ([responseObject[@"code"] isEqual:@0]) {
        [self showAlertWithMessage:@"没有数据"];
        //修改公司time中任务数目
        [TimeLocalDao modifyTaskCount:self.selectState.ipAddress company:self.selectState.companyName ndid:self.selectState.ndid count:0];
        return;
    }
//    else {
//        [_dataArray addObjectsFromArray:[NetDataToEntity setMyValue:responseObject[@"data"] className:NSStringFromClass([CostDetailInfo class])]];
//        [_tableView reloadData];
//        [_totalArray addObjectsFromArray:[NetDataToEntity setMyValue:responseObject[@"data"] className:NSStringFromClass([CostDetailInfo class])]];
//    }
    
//    [EntityOneDao deleteWithEntityName:@"DetailLocal" predicate:nil];
    for(NSDictionary *dic in responseObject[@"data"]) {
        [DetailLocalDao insertDataWithDic:dic];
    }
    [self getDataFromDataSource];
    [_tableView reloadData];
    //修改公司time中任务数目
    [TimeLocalDao modifyTaskCount:self.selectState.ipAddress company:self.selectState.companyName ndid:self.selectState.ndid count:_totalArray.count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%ld",section + 1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CostDetailInfo *info = _dataArray[indexPath.section][indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costDetail"];
    UILabel *titlelabel = (UILabel *)[cell viewWithTag:11];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:12];
    UILabel *moneyLabel = (UILabel *)[cell viewWithTag:13];
    UILabel *bianhao = (UILabel *)[cell viewWithTag:14];
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@ %@%@",info.jzsj,info.pzzl,info.pzbh];
    bianhao.text = [NSString stringWithFormat:@"科目编号:%@",info.kmbh];
    [title replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, title.length)];
    titlelabel.text = title;
    contentLabel.text = [NSString stringWithFormat:@"摘要:%@",info.sm];
    
    char c = [info.dffse characterAtIndex:0];
    
    if(c == 48) {
        NSNumber *num = [NSNumber numberWithFloat:[info.jffse floatValue]];
        NSNumberFormatter *formater=[[NSNumberFormatter alloc] init];
        [formater setNumberStyle: NSNumberFormatterCurrencyStyle];
        moneyLabel.text = [NSString stringWithFormat:@"贷方发生额:%@",[formater stringFromNumber:num]];
    } else {
        NSNumber *num = [NSNumber numberWithFloat:[info.jffse floatValue]];
        NSNumberFormatter *formater=[[NSNumberFormatter alloc] init];
        [formater setNumberStyle: NSNumberFormatterCurrencyStyle];
        moneyLabel.text = [NSString stringWithFormat:@"借方发生额:%@",[formater stringFromNumber:num]];
    }
    
    //判断是否在数据库里面存在附件,如果存在,显示为蓝色
    if([PhotosDao hasData:self.selectState.sdbGuid ipAddress:self.selectState.ipAddress dwid:self.selectState.dwid ndid:self.selectState.ndid iden:info.iden]) {
        titlelabel.textColor = COLOR4(50, 50, 150, 1);
        contentLabel.textColor = COLOR4(50, 50, 150, 1);
        moneyLabel.textColor = COLOR4(50, 50, 150, 1);
    } else {
        titlelabel.textColor = [UIColor blackColor];
        contentLabel.textColor = [UIColor blackColor];
        moneyLabel.textColor = [UIColor blackColor];
    };
    
    //给cell添加长按手势
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressed:)];
    [cell addGestureRecognizer:gesture];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return;
//    _nowSelected = indexPath.row;
//    [self saveStatus];

    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HomePhotoController *controller = [storyboard instantiateViewControllerWithIdentifier:@"homePhoto"];
//    [self.navigationController pushViewController:controller animated:YES];
//    controller.delegate = self;
    
    [self getAllDataArr];
    
    _alertController = [self.storyboard instantiateViewControllerWithIdentifier:@"costDetailAlert"];
    CostDetailInfo *info = _dataArray[indexPath.section][indexPath.row];
    _alertController.data = [IdenAlertData backDataFromArray:_allDataArr idenCode:info.pzbh];
    _alertController.delegate = self;
    _alertController.info = info;
    _pzbhArray = [IdenAlertData backPzbhArrayFromArray:_allDataArr];
    _pzbhIndex = [_pzbhArray indexOfObject:info.pzbh];
    [self.navigationController pushViewController:_alertController animated:YES];

    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)cellLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
}

- (void)backLeftOrRightSwipe:(UISwipeGestureRecognizerDirection)direction
{
    if(direction == UISwipeGestureRecognizerDirectionLeft) {
        _pzbhIndex ++;
        if(_pzbhIndex == _pzbhArray.count) {
            _pzbhIndex --;
            [self showAlertWithMessage:@"已经是最后一个"];
        } else {
            _alertController.data = [IdenAlertData backDataFromArray:_allDataArr idenCode:_pzbhArray[_pzbhIndex]];
        }
    } else {
        _pzbhIndex --;
        if(_pzbhIndex == -1) {
            _pzbhIndex = 0;
            [self showAlertWithMessage:@"已经是第一个"];
        } else {
            _alertController.data = [IdenAlertData backDataFromArray:_allDataArr idenCode:_pzbhArray[_pzbhIndex]];
        }
    }
}

#pragma mark - chooseControllerDelegate
- (void)backController
{
    _page = 0;
    [_dataArray removeAllObjects];
    [_totalArray removeAllObjects];
    [self getDataFromDataSource];
}

//进入照相
- (IBAction)takePhone:(id)sender {
    NSIndexPath *indexPath;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
     indexPath = [_tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    } else {
        indexPath = [_tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];

    }
//    _nowSelected = indexPath.row;
    [self saveStatus:indexPath];
 
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomePhotoController *controller = [storyboard instantiateViewControllerWithIdentifier:@"homePhoto"];
    [self.navigationController pushViewController:controller animated:YES];
    controller.delegate = self;
//    controller.fromBottom = NO;
}

//保存当前状态,根据index
- (void)saveStatus:(NSIndexPath *)indexPath
{
    CostDetailInfo *info = _dataArray[indexPath.section][indexPath.row];
    self.selectState.iden = info.iden;
    self.selectState.taskDetail = [NSString stringWithFormat:@"%@ %@%@",info.jzsj,info.pzzl,info.pzbh];
    char c = [info.dffse characterAtIndex:0];
    self.selectState.taskTime = info.jzsj;
    self.selectState.taskThing = [NSString stringWithFormat:@"%@%@",info.pzzl,info.pzbh];
    NSString *thing ;
    if(c == 48) {
        thing = [NSString stringWithFormat:@"贷:%@",info.jffse];
    } else {
        thing = [NSString stringWithFormat:@"借:%@",info.dffse];
    }
    self.selectState.thing = thing;
    self.selectState.takeMoney = info.sm;
    self.selectState.indexTotalStr = [NSString stringWithFormat:@"拍摄任务:%ld/%lu",(long)_nowSelected + 1,(unsigned long)_dataArray.count];
}

//过滤,只保存无附件的凭证
- (IBAction)filter:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    _isFilter = button.selected;
    [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    if(button.selected) {
        _dataArray = [TokePhone filter:_dataArray];
    } else {
        _dataArray = _totalArray;
    }
    [_tableView reloadData];
}

//底部的拍照
- (IBAction)takePhoneBottom:(id)sender {
    if(_totalArray.count == 0) {
        [self showAlertWithMessage:@"当前没有凭证"];
        return;
    }
    
//    _nowSelected = 0;
//    [self saveStatus];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomePhotoController *controller = [storyboard instantiateViewControllerWithIdentifier:@"homePhoto"];
    [self.navigationController pushViewController:controller animated:YES];
    controller.dataArray = _totalArray;
    controller.nowSelected = _nowSelected;
    controller.fromBottom = YES;
    controller.delegate = self;
}


 


//- (void)backController:(NSInteger)index
//{
//    _nowSelected = index;
//    [self saveStatus];
//}

@end
