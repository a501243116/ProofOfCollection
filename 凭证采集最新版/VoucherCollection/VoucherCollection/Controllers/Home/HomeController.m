//
//  HomeController.m
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "HomeController.h"
#import "SearchTextField.h"
#import "InputPwdController.h"
#import "CheckServer.h"
#import "UIView+AutoLayout.h"
#import "EntityOneDao.h"
#import "IPInfoDao.h"
#import "IPInfos.h"
#import "HomeFilter.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "NoServerView.h"
#import "TaskController.h"
//屏幕的宽高
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HomeController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CheckServerDelegate,InputPwdVcDelegate,SearchTextFieldDelegate,NOServerViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_totalArray;
    SearchTextField *_searTextField;
    UISearchBar *_searchBar;
    NSDictionary *_selectDic;
    NSArray *_dataBaseData;
    NSInteger _ipId;
    NSMutableArray *_filterArray;//用于搜索栏搜索,记录第一个Label的文字
    BOOL _isRefresh;//用于判断是否是刷新了界面获取table,还是过滤
    BOOL _lasthasEnd;//用于判断上一次刷新是否结束
    MBProgressHUD *_hud;
    NoServerView *_noServerView;//没有搜索到服务器界面
    CheckServer *_checkServer;
    NSMutableDictionary *_jsjNamesDic;
    NSInteger _hasDataCount;
    UIButton *_cancelButton;//取消输入框
    BOOL _isConnect;
}

@end

@implementation HomeController

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"refreshServer_not" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    NSLog(@"%@",NSHomeDirectory());
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"服务器";
    self.isInWifi = [CheckServer isInWifi];
    self.selectState.isInWifi = self.isInWifi;
//    [self setDataArray];
}

//从数据库更新数据,主要为了刷新被审时间和单位
- (void)refreshDataBaseData
{
    //获取数据库数据
    _ipId = [self.defaults integerForKey:@"ipId"];
    if(_ipId != 0) {
        _dataBaseData = [EntityOneDao readObjectWithEntityName:NSStringFromClass([IPInfos class]) predicate:nil];
    }
    [_tableView reloadData];
    
}

- (void)endHud
{
    [_hud removeFromSuperview];
    _hud = nil;
}

- (void)setDataArray
{
    if(!_lasthasEnd) {
        return;
    }
    _lasthasEnd = NO;
    
    self.isInWifi = [CheckServer isInWifi];
    self.selectState.isInWifi = self.isInWifi;
    
    [_dataArray removeAllObjects];
    [_totalArray removeAllObjects];
    [_jsjNamesDic removeAllObjects];
    [_tableView reloadData];
    //获取数据库数据
    _ipId = [self.defaults integerForKey:@"ipId"];
    if(_ipId != 0) {
        _dataBaseData = [EntityOneDao readObjectWithEntityName:NSStringFromClass([IPInfos class]) predicate:nil];
        NSString *nowIp = [self.defaults stringForKey:@"rootUrl"];
        nowIp = [nowIp substringWithRange:NSMakeRange(7, nowIp.length - 12)];
       IPInfos *ipInfo = (IPInfos *)[IPInfoDao readDataByIp:nowIp];
        self.selectState.selectIpInfo = ipInfo;
        
        for(IPInfos *ipInfo in _dataBaseData ) {
            [_dataArray addObject:ipInfo.ipAddress];
            [_totalArray addObject:ipInfo.ipAddress];
            [_tableView reloadData];
        }
        

    }
    //如果没有在wifi网络中
    if(!self.isInWifi) {
        if(_ipId == 0) {
            [self showAlertWithMessage:@"没有在WIFI网络中,且本地无数据"];
            return;
        }
        for(IPInfos *ipInfo in _dataBaseData) {

            [_dataArray addObject:ipInfo.ipAddress];
            [_totalArray addObject:ipInfo.ipAddress];
            [_tableView reloadData];
        }
        
    } else {
        [self refreshTableView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeApperance];
    self.navigationItem.leftBarButtonItem = nil;
//    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    //监听从选择项目来的通知
    _lasthasEnd = YES;
    [self setDataArray];
    //添加bar上的加号按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"icon_tj_n.png"] forState:UIControlStateNormal];
    rightButton.bounds = CGRectMake(0, 0, 30, 30);
    [rightButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectState:) name:CONNECTSTATE object:nil];
}

- (void)updateConnectState:(NSNotification *)info
{
    _isConnect  = [[info object] boolValue];
    [_tableView reloadData];
}

- (void)rightItemClick
{
    [_noServerView showInputIpView];
}


- (void)initializeApperance
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 85;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak id myself = self;
    [_tableView addHeaderWithCallback:^{
        [myself setDataArray];
        
    }];
    _tableView.headerRefreshingText = @"正在刷新";
    
    self.searchStr = _searTextField.text;
    
    _searchBar = [[UISearchBar alloc] initForAutoLayout];
    [_topView addSubview:_searchBar];
        [_searchBar autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:0.9];
        [_searchBar autoSetDimension:ALDimensionHeight toSize:40];
        [_searchBar autoCenterInSuperview];
        [_searchBar layoutIfNeeded];
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.layer.borderWidth = 8;
    _searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    _searchBar.layer.cornerRadius = 5;
    _searchBar.delegate = self;
    _searchBar.layer.masksToBounds = YES;
    
    _noServerView = [[NoServerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_tableView.bounds))];
    _noServerView.delegate = self;
    _noServerView.hidden = YES;
    _noServerView.tipLabel.text = @"没有搜索到服务器,请确认相关服务是否\n启动,并下拉刷新";
    [_tableView addSubview:_noServerView];
    
    //点击输入框覆盖tableview,用于取消输入
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _cancelButton.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    _cancelButton.backgroundColor = [UIColor clearColor];
    [_cancelButton addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.hidden = YES;
    [self.view addSubview:_cancelButton];
}

- (void)cancelInput
{
    [_searchBar resignFirstResponder];
    _cancelButton.hidden = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
//    static BOOL first = YES;//只有第一次才会判断
//    if(!first) {
//        return;
//    }
//    [self setDataArray];
//    first = NO;
}

- (void)initializeDataSource
{
    _dataArray = [[NSMutableArray alloc] init];
    _totalArray = [NSMutableArray new];
    _filterArray = [NSMutableArray new];
    _jsjNamesDic = [NSMutableDictionary new];
    _isRefresh = YES;
    
}

#pragma mark NoServerDelegate
- (void)refreshButtonPressed
{
    _noServerView.hidden = YES;
    [self setDataArray];
}

- (void)inputMessage:(NSString *)message1 message2:(NSString *)message2 message3:(NSString *)message3 message4:(NSString *)message4
{
    _noServerView.hidden = YES;
    _checkServer = nil;
    _checkServer = [[CheckServer alloc] init];
    _checkServer.delegate = self;
    [_checkServer getSerVerWithIp1:message1 ip2:message2 ip3:message3 ip4:message4];
}

#pragma mark NetserverDelegate
- (void)getIp:(NSString *)address
{
    _isConnect = YES;
    if([_dataArray containsObject:address]) {
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
        return ;
    }
    
    _hasDataCount ++;
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080/pzcj/computerInfo.sht",address];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"a2b2755d2be2a70c187d300f14f09d27" forKey:@"key"];
    [self.manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [_jsjNamesDic setValue:responseObject[@"data"][@"jsjName"] forKey:address];
        [_dataArray addObject:address];
        [_totalArray addObject:address];
        _isRefresh = YES;
        //通知主线程更新页面
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _hasDataCount --;
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
    }];

}

- (void)endCheck
{
    _lasthasEnd = YES;
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
  
}

- (void)updateUI
{
    if(_dataArray.count != 0 || _lasthasEnd == YES) {
    [self endHud];
    }
    [_tableView reloadData];
    if(_dataArray.count == 0 && _lasthasEnd == YES && _hasDataCount == 0) {
        _noServerView.hidden = NO;
    }
    [_tableView headerEndRefreshing];
    if(_dataArray.count != 0)
    {
        _noServerView.hidden = YES;
    }
}


//刷新列表
- (void)refreshTableView
{
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.labelText = @"Loading";
    [self.view addSubview:_hud];
    if (![_tableView isHeaderRefreshing]) {
        [_hud show:YES];
    }
    _checkServer = nil;
    _checkServer = [[CheckServer alloc] init];
    _checkServer.delegate = self;
    _isConnect = NO;
    [_checkServer getServerIp];
}

//- (UIImage *)backAdminImage
//{
//    NSInteger randomNum = arc4random() % 4 + 1;
//    NSString *admin = [NSString stringWithFormat:@"admin%ld",(long)randomNum];
//    return [UIImage imageNamed:admin];
//}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isRefresh && indexPath.row == 0) {
    [_filterArray removeAllObjects];
    }
    
    //从数据库中读取数据
    for(IPInfos *ipInfo in _dataBaseData) {
        if([ipInfo.ipAddress isEqualToString:_dataArray[indexPath.row]])
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *textLabel = (UILabel *)[cell viewWithTag:11];
            UILabel *timeLabel = (UILabel *)[cell viewWithTag:12];
            UILabel *companyLabel = (UILabel *)[cell viewWithTag:13];
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:21];
            UIImageView *tempImageView = (UIImageView *)[cell viewWithTag:55];
            tempImageView.hidden = !_isConnect;
            
//            imageView.image = [self backAdminImage];
            imageView.image = [UIImage imageNamed:@"computer_three"];
            if (!_isConnect) {
                imageView.image = [UIImage imageNamed:@"deflut_icon"];
            }
            textLabel.text = [NSString stringWithFormat:@"计算机:%@",ipInfo.name];
            timeLabel.text = ipInfo.time;
            if (![ipInfo.company isEqualToString:@""]) {
                companyLabel.text = [NSString stringWithFormat:@"被审单位:%@",ipInfo.company];

            }else
            {
                companyLabel.text = nil;
            }
            //添加text到过滤数组
            if(_isRefresh) {
            HomeFilter *homeF = [HomeFilter new];
            homeF.index = indexPath.row;
            homeF.text = textLabel.text;
            [_filterArray addObject:homeF];
            }
            if(indexPath.row == _totalArray.count - 1) {
                _isRefresh = NO;
            }
            
            return cell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:11];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:21];
    imageView.image = [UIImage imageNamed:@"computer_three"];
//    imageView.image = [self backAdminImage];
    textLabel.text = [NSString stringWithFormat:@"计算机:%@",_jsjNamesDic[_dataArray[indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加text到过滤数组
    if (_isRefresh) {
    HomeFilter *homeF = [HomeFilter new];
    homeF.index = indexPath.row;
    homeF.text = textLabel.text;
    [_filterArray addObject:homeF];
    }
    
    if(indexPath.row == _totalArray.count - 1) {
        _isRefresh = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str;
    for(IPInfos *ipInfo in _dataBaseData) {
        if([ipInfo.ipAddress isEqualToString:_dataArray[indexPath.row]])
        {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TaskController *taskController = (TaskController *)[storyBoard instantiateViewControllerWithIdentifier:@"task"];
            taskController.ipAdress = _dataArray[indexPath.row];
//            taskController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:taskController animated:YES];
            

            //保存地址在userdefauls里面
            str = [NSString stringWithFormat:@"http://%@:8080",ipInfo.ipAddress];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:str forKey:@"rootUrl"];
            [defaults synchronize];
            
            //保存操作状态
            self.selectState.ipAddress = _dataArray[indexPath.row];
            self.selectState.selectIpInfo = ipInfo;
            
            return;
        }
    }
    
    InputPwdController *controller = [[InputPwdController alloc] init];
    controller.ipAddress = _dataArray[indexPath.row];
    controller.delegate = self;
    controller.isFirst = YES;
    controller.hidesBottomBarWhenPushed = YES;
    controller.ipAddress = _dataArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"ipAddress == %@",_dataArray[indexPath.row]];
        [EntityOneDao deleteWithEntityName:@"IPInfos" predicate:pre];
        [EntityOneDao deleteWithEntityName:@"Company" predicate:pre];
        [EntityOneDao deleteWithEntityName:@"DetailLocal" predicate:pre];
        [EntityOneDao deleteWithEntityName:@"ExamineIden" predicate:pre];
        [EntityOneDao deleteWithEntityName:@"Photos" predicate:pre];
        [EntityOneDao deleteWithEntityName:@"TimeLocal" predicate:pre];
        [_tableView reloadData];
    }
}

#pragma mark - InputPwdControllerDelgate
- (void)backJsJID:(NSDictionary *)dic
{
    _ipId = [self.defaults integerForKey:@"ipId"];
    if(_ipId != 0) {
        _dataBaseData = [EntityOneDao readObjectWithEntityName:NSStringFromClass([IPInfos class]) predicate:nil];
    }
    [_tableView reloadData];
}

#pragma mark - SearchBarDelegate

- (void)searchButtonPressed
{
    [self search:_searTextField.text];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *str = searchText;
    if(str.length == 0) {
        [_dataArray removeAllObjects];
        for(HomeFilter *homeF in _filterArray) {
            [_dataArray addObject:_totalArray[homeF.index]];
        }
        [_tableView reloadData];
        return ;
    }
    
    //定义谓词
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"text CONTAINS %@",str];
    NSMutableArray *filterArray = [NSMutableArray arrayWithArray:_filterArray];
    [filterArray filterUsingPredicate:pre];
    [_dataArray removeAllObjects];
    for(HomeFilter *homeF in filterArray) {
        [_dataArray addObject:_totalArray[homeF.index]];
    }
    [_tableView reloadData];
}

//添加一个全屏的取消输入视图
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _cancelButton.hidden = NO;
   
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self search:@""];
}

- (void)search:(NSString *)str
{
    if(str.length == 0) {
        [_dataArray removeAllObjects];
        for(HomeFilter *homeF in _filterArray) {
            [_dataArray addObject:_totalArray[homeF.index]];
        }
        [_tableView reloadData];
        return ;
    }
    
    //定义谓词
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"text CONTAINS %@",str];
    NSMutableArray *filterArray = [NSMutableArray arrayWithArray:_filterArray];
    [filterArray filterUsingPredicate:pre];
    [_dataArray removeAllObjects];
    for(HomeFilter *homeF in filterArray) {
        [_dataArray addObject:_totalArray[homeF.index]];
    }
    [_tableView reloadData];
}



@end
