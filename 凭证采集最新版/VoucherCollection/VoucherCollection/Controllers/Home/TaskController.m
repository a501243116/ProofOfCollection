//
//  TaskController.m
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

/*被审计单位页面*/

#import "TaskController.h"
#import "ChooseTaskController.h"
#import "CompanyDao.h"
#import "ParseChooseTaskData.h"
#import "SpreadClass.h"
#import "SpreadData.h"
#import "NdidToTime.h"
#import "HeadView.h"
#import "CompanyTask.h"
#import "CostDetailController.h"
#import "CompanyTask.h"
#import "Company.h"
#import "InputPwdController.h"
#import "MBProgressHUD.h"
#import "RATableViewCell.h"
#import "EntityOneDao.h"
#import "RATreeView+Private.h"
#import "GLFontSize.h"

@interface TaskController()<UISearchBarDelegate,RATreeViewDelegate,RATreeViewDataSource,UITextFieldDelegate,ChooseTaskControllerDelegate>
{
    NSString *_dbGuid;
    NSString *_projectName;
    NSMutableArray *_dataArray;
    NSArray *_showArray;
    NSMutableArray *_spreadDatas;
    NSMutableArray *_dbs;
    NSMutableArray *_totalArray,*_tempArray;
    UIButton *_cancelButton;
    UIButton *_headView;
    UILabel *_headView_Label;
    NSString *_openTitle;
    CGRect _celltempFrame;
}
@end

@implementation TaskController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_tj_n.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addProject)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    _tableView.alpha = 0.0;
    [self initializeDataSource];
    [self initializeApperance];
    [self getDataFromDataBase];
    [self netTask:DATABASE_URL];
}

- (void)initializeDataSource
{
    _showArray = [NSArray new];
    _spreadDatas = [NSMutableArray new];
    _dataArray = [NSMutableArray new];
    _totalArray = [NSMutableArray new];
    _dbs = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataFromDataBase];
}

- (void)getDataFromDataBase
{
    [_dataArray removeAllObjects];
    [_raTreeView.tableView headerEndRefreshing];

//    if(_dbGuid == nil) {
//        return;
//    }
    _showArray = [CompanyDao readDataWithIp:self.selectState.ipAddress];
    
    //获取数据库ID
    [_showArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
        Company *company = obj[0];
        NSDictionary *dic = @{@"dbID":company.dbID,@"dbName":company.dbName};
        [_dbs addObject:dic];
    }];

    [_showArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
        Company *company = obj[0];
        NSString *title = [company.dbName copy];
            obj = [ParseChooseTaskData backDictionArrayFromCompanyObj:obj];
            obj = [ParseChooseTaskData backNdidData:obj];
        [self initializeShowArray:obj index:idx title:title];
    }];
    
//    _tableView.alpha = 1.0;
//    [self resetOpen];
//    [_tableView reloadData];
    
    
    
    [_raTreeView reloadData];
    _totalArray = [self arrayCopy:_dataArray];
    _tempArray = [self arrayCopy:_dataArray];
    
}

- (void)openTitle:(NSString *)title
{
    _openTitle = title;
    if (title) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"list_open"];
    }
}

- (void)initializeShowArray:(NSArray *)array index:(NSInteger)index title:(NSString *)title
{
    SpreadClass *parentSc = [SpreadClass new];
    parentSc.isOPen = NO;
    parentSc.title = title;
    if ([title isEqualToString:_projectName]) {
        _raTreeView.treeHeaderView = nil;
    }
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"list_open"];
    NSArray *arr = dic[parentSc.title];
    if (arr.count > 0) {
        parentSc.isOPen = YES;
    }
    if (_openTitle) {
        parentSc.isOPen = YES;
    }
    for(NdidToTime *obj in array) {
        SpreadClass *sc = [SpreadClass new];
        sc.isOPen = NO;
        sc.title = obj.duringTime;
        sc.childArray = obj.childArray;
        if (_openTitle && [parentSc.title isEqualToString:_projectName] && [_openTitle isEqualToString:sc.title]) {
            sc.isOPen = YES;
            _openTitle = nil;
        }
        for (int i=0; i<arr.count; i++) {
            if ([sc.title isEqualToString:arr[i]]) {
                sc.isOPen = YES;
                break;
            }
        }
        
        [parentSc.childArray addObject:sc];
    }
    
    [_dataArray addObject:parentSc];
    SpreadData *sd1= [[SpreadData alloc] initWithSpreedClass:parentSc section:index];
    [_spreadDatas addObject:sd1];
}

- (void)initializeApperance
{
    self.view.backgroundColor = COLOR4(220, 220, 220, 1);
    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.layer.borderWidth = 8;
    _searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    _searchBar.layer.cornerRadius = 5;
    _searchBar.delegate = self;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.returnKeyType = UIReturnKeySearch;
    
//    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 60)];
//    whiteBgView.backgroundColor = [UIColor whiteColor];
//    [self.view insertSubview:whiteBgView atIndex:0];


//    __weak id weakSelf = self;
//    [_tableView addHeaderWithCallback:^{
//        [weakSelf getDataFromDataBase];
//    }];
//    _tableView.headerRefreshingText = @"正在刷新";
    //点击输入框覆盖tableview,用于取消输入
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _cancelButton.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    _cancelButton.backgroundColor = [UIColor clearColor];
    [_cancelButton addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.hidden = YES;
    [self.view addSubview:_cancelButton];
    
    _raTreeView.delegate = self;
    _raTreeView.dataSource = self;
    __weak id weakSelf = self;
    [_raTreeView.tableView addHeaderWithCallback:^{
        [weakSelf getDataFromDataBase];
    }];
    _raTreeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    _headView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _headView.frame = CGRectMake(0, 0, CGRectGetWidth(_raTreeView.frame), 30);
    [_headView addTarget:self action:@selector(addProject) forControlEvents:UIControlEventTouchUpInside];
    _headView.backgroundColor = [UIColor whiteColor];
    _headView_Label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    _headView_Label.font = [UIFont systemFontOfSize:11];
    _headView_Label.textColor = [UIColor blueColor];
    _headView_Label.text = @"新    未连接";
    [_headView addSubview:_headView_Label];
    
    UILabel *jiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, 0, 13, 30)];
    jiaLabel.text = @"＋";
    jiaLabel.textColor = _headView_Label.textColor;
    jiaLabel.font = _headView_Label.font;
    [_headView addSubview:jiaLabel];
    _raTreeView.treeHeaderView = _headView;
}

- (void)cancelInput
{
    [_searchBar resignFirstResponder];
    _cancelButton.hidden = YES;
}

- (void)netTask:(NSString *)urlStr
{
    [super netTask:urlStr];
    [self endMBProgressHud];

    [self.manager POST:self.url parameters:self.netDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dbGuid = responseObject[@"data"][@"dbGuid"];
        _projectName = responseObject[@"data"][@"projectName"];
        self.selectState.dbGuid = _dbGuid;
        self.selectState.projectName = _projectName;
//        _nowPrj.text = [NSString stringWithFormat:@"新          %@",_projectName];
        _headView_Label.text = [NSString stringWithFormat:@"新          %@",_projectName];
        [self getDataFromDataBase];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertWithMessage:@"网络错误"];
    }];
}

- (void)addProject {
    if(self.selectState.dbGuid == nil) {
        [self showAlertWithMessage:@"未连接"];
        return;
    }
    NSLog(@"%@",[self.storyboard instantiateViewControllerWithIdentifier:@"chooseTask"]);
    ChooseTaskController *controller = (ChooseTaskController *)[self.storyboard instantiateViewControllerWithIdentifier:@"chooseTask"];
    controller.name = _projectName;
    controller.delegate = self;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller  animated:YES];
}


//- (void)isPwdcorrect
//{
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:hud];
//    [hud show:YES];
//    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:_ipAdress];
//    [self.netDic setValue:@"a2b2755d2be2a70c187d300f14f09d27" forKey:@"key"];
//    [self.netDic setValue:pwd forKey:@"passKey"];
//    NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080/pzcj/computerLogin.sht",_ipAdress];
//    [self.manager POST:urlStr parameters:self.netDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject[@"code"] isEqual:@0]) {
//            InputPwdController *controller = [[InputPwdController alloc] init];
//            controller.ipAddress =_ipAdress;
//            [self.navigationController pushViewController:controller animated:YES];
//        }else
//        {
//            ChooseController *controller = (ChooseController *)[self.storyboard instantiateViewControllerWithIdentifier:@"chooseTask"];
//            [self.navigationController pushViewController:controller  animated:YES];
//        }
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showAlertWithMessage:@"网络错误"];
//        [hud hide:YES];
//    }];
//}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SpreadClass *sc = _dataArray[section];
    if(sc.isOPen == NO) {
        return 0;
    } else {
        int count = (int)sc.childArray.count;
        for(SpreadClass *childSc in sc.childArray) {
            if(childSc.isOPen) {
                count += childSc.childArray.count;
            }
        }
        return count;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    SpreadClass *parentSc = _dataArray[indexPath.section];
    
    SpreadData *sd = _spreadDatas[indexPath.section];
    NSDictionary *dic = [sd backPostionWithIndex:indexPath.row];
    if([dic[@"isHeader"] isEqual:@1]) {
        SpreadClass *sc = parentSc.childArray[[dic[@"position"] integerValue]];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        UILabel *label = (UILabel *)[cell viewWithTag:11];
        label.text = sc.title;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        UILabel *label = (UILabel *)[cell viewWithTag:11];
        SpreadClass *sc = parentSc.childArray[[dic[@"position1"] integerValue]];
        NSInteger position2 = [dic[@"position2"] integerValue] - 1;
        CompanyTask *task = sc.childArray[position2];
        label.text = task.xmcc;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HeadView *headView = [HeadView headViewWithTableView:_tableView];
    
    headView.delegate = self;
    headView.sc = _dataArray[section];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = COLOR4(220, 220, 220, 1);
    [headView addSubview:lineView];
    
    UILabel *conLabel = [UILabel new];
    conLabel.bounds = CGRectMake(0, 0, 70, 25);
    conLabel.center = CGPointMake(SCREEN_WIDTH - 45, 25);
    conLabel.font = [UIFont systemFontOfSize:11];
    conLabel.textAlignment = NSTextAlignmentRight;
    SpreadClass *sc = _dataArray[section];
    if([sc.title isEqualToString:_projectName]) {
        conLabel.textColor = COLOR4(126, 160, 210, 1);
        conLabel.text = @"连接中";
    } else {
        conLabel.textColor = COLOR4(100, 100, 100, 1);
        conLabel.text = @"未连接";
    }
    [headView addSubview:conLabel];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//设置表头跟着滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = 20; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"cell1"]) {
        SpreadData *sd = _spreadDatas[indexPath.section];
        SpreadClass *parentSc = _dataArray[indexPath.section];
        NSInteger index = [[sd backPostionWithIndex:indexPath.row][@"position"] integerValue];
        SpreadClass *sc = parentSc.childArray[index];
        sc.isOPen = !sc.isOPen;
        UIImageView *dropImageView = (UIImageView *)[cell viewWithTag:12];
            dropImageView.transform = sc.isOPen ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
        
        sd = [[SpreadData alloc] initWithSpreedClass:parentSc section:indexPath.section];
        [_spreadDatas replaceObjectAtIndex:indexPath.section withObject:sd];
        
        [tableView reloadData];
    } else {
        SpreadData *sd = _spreadDatas[indexPath.section];
        NSDictionary *dic = [sd backPostionWithIndex:indexPath.row];
        NSLog(@"section:%ld\nposition1:%@\nposition2:%@ - 1",(long)indexPath.section,dic[@"position1"],dic[@"position2"]);
        [self turnToIdenController:indexPath.section time:[dic[@"position1"] integerValue] position:[dic[@"position2"]  integerValue] - 1];
    }
    
}
*/
- (void)turnToIdenController:(RATreeNodeInfo *)treeNodeInfo
{
    SpreadClass *obj = treeNodeInfo.parent.item;
    CompanyTask *task = treeNodeInfo.item;
    CostDetailController *controller = (CostDetailController *)[self.storyboard instantiateViewControllerWithIdentifier:@"costDetail"];
    controller.hidesBottomBarWhenPushed = YES;
    controller.titleTime = task.xmcc;
    controller.ndId = task.ndid;
    controller.dwid = task.dwid;
    controller.prjName = _projectName;
    //保存信息在单例中
    self.selectState.companyName = task.xmcc;
    self.selectState.companyTime = obj.title;
    self.selectState.dwid = task.dwid;
    self.selectState.ndid = task.ndid;
    NSDictionary *dic = _dbs[treeNodeInfo.parent.parent.positionInSiblings];
    self.selectState.sdbGuid = dic[@"dbID"];
    self.selectState.sprojectName = dic[@"dbName"];
    
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickHeadView
{
//    [_tableView reloadData];
}

#pragma mark
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self search:searchText];
}

- (NSMutableArray *)arrayCopy:(NSMutableArray *)array
{
    NSMutableArray *newArray = [NSMutableArray new];
    for(SpreadClass *parentSc in array) {
        
        NSMutableArray *newParentScArray = [NSMutableArray new];
        SpreadClass *newParentSc = [SpreadClass new];
        newParentSc.title = parentSc.title;
        newParentSc.isOPen = parentSc.isOPen;
        newParentSc.childArray = newParentScArray;
        [newArray addObject:newParentSc];
        
        for(SpreadClass *sc in parentSc.childArray) {
            
            NSMutableArray *newScArray = [NSMutableArray new];
            SpreadClass *newSc = [SpreadClass new];
            newSc.isOPen = sc.isOPen;
            newSc.title = sc.title;
            newSc.childArray = newScArray;
            [newParentScArray addObject:newSc];
            
            for(CompanyTask *task in sc.childArray) {
                
                CompanyTask *newTask = [CompanyTask new];
                newTask.ndid = task.ndid;
                newTask.dwid = task.dwid;
                newTask.xmcc = task.xmcc;
                newTask.company = task.company;
                [newScArray addObject:newTask];
                
            }
        }
    }
    return newArray;
}

//- (void)resetOpen
//{
//    for(SpreadClass *sc in _dataArray) {
//        sc.isOPen = NO;
//        for(SpreadClass *childSc in sc.childArray) {
//            childSc.isOPen = NO;
//        }
//    }
//}

- (void)search:(NSString *)str
{
    if(str == nil || str.length == 0) {
        _totalArray = [self arrayCopy:_tempArray];
        _dataArray = [self arrayCopy:_tempArray];
//        [self resetOpen];
        [_raTreeView  reloadData];
        return;
    }
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"xmcc CONTAINS %@",str];
    
    for(int i = 0;i < _totalArray.count;i ++) {
        SpreadClass *sc = _totalArray[i];
        if ([sc.title rangeOfString:str].length) {
            continue;
        }
        for(int ii = 0;ii < sc.childArray.count;ii ++) {
            SpreadClass *childSc = sc.childArray[ii];
            if ([childSc.title rangeOfString:str].length) {
                continue;
            }
            [childSc.childArray filterUsingPredicate:pre];
            if(childSc.childArray.count == 0) {
                [sc.childArray removeObject:childSc];
                ii --;
            }
        }
        if(sc.childArray.count == 0) {
            [_totalArray removeObject:sc];
            i --;
        }
    }
    _dataArray = [self arrayCopy:_totalArray];
    _totalArray = [self arrayCopy:_tempArray];
    
    [_spreadDatas removeAllObjects];
    [_dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SpreadData *sData = [[SpreadData alloc] initWithSpreedClass:obj section:idx];
        [_spreadDatas addObject:sData];
    }];
    
//    [self resetOpen];
    [_raTreeView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self search:searchBar.text];
    [searchBar resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//添加一个全屏的取消输入视图
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _cancelButton.hidden = NO;
    
    return YES;
}


#pragma mark -- RATreeView
#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 44;
}

//- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
//{
//    return 3 * treeNodeInfo.treeDepthLevel;
//}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    
    if ([item isKindOfClass:[SpreadClass class]]) {
        SpreadClass *sc = item;
        return sc.isOPen;
    }
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0  blue:247.0/255.0  alpha:1];
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0  blue:240.0/255.0  alpha:1];
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0  blue:230/255.0  alpha:1];
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    RATableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld",treeNodeInfo.treeDepthLevel]];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RATableViewCell" owner:nil options:nil] [treeNodeInfo.treeDepthLevel];
        if ([item isKindOfClass:[CompanyTask class]]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(69, 0, 0, 44)];
            label.tag = 999;
            label.font = cell.label.font;
            label.textColor = cell.label.textColor;
            [cell.contentView addSubview:label];
            _celltempFrame = label.frame;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xialaImage.image = [UIImage imageNamed:@"drop_normal.png"];
    if ([item isKindOfClass:[SpreadClass class]]) {
        SpreadClass *sc = item;
        cell.xialaImage.transform = sc.isOPen ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
        cell.label.text = sc.title;
        
        if (treeNodeInfo.treeDepthLevel == 0) {
            if([sc.title isEqualToString:_projectName]) {
                cell.conLabel.textColor = COLOR4(126, 160, 210, 1);
                cell.conLabel.text = @"连接中";
                [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTSTATE object:@YES];
            } else {
                cell.conLabel.textColor = COLOR4(100, 100, 100, 1);
                cell.conLabel.text = @"未连接";
                [[NSNotificationCenter defaultCenter] postNotificationName:CONNECTSTATE object:@NO];
            }
        }
        
        
        
        
    }else if ([item isKindOfClass:[CompanyTask class]])
    {
        
        CompanyTask *sc = item;
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:999];
        label.frame = _celltempFrame;
        label.text = sc.xmcc;
//        cell.label.backgroundColor = [UIColor redColor];
        CGRect tempFrame = label.frame;
        tempFrame.size.width = [GLFontSize sizeWithString:sc.xmcc font:cell.label.font width:10000].width;
        label.frame = tempFrame;
        NSLog(@"%f",label.frame.origin.x);
        NSLog(@"%f",CGRectGetMaxX(label.frame));
        if (CGRectGetMaxX(label.frame) > CGRectGetMaxX(self.view.frame)) {
//            label.backgroundColor = [UIColor redColor];
            [UIView beginAnimations:@"testAnimation" context:NULL];
            [UIView setAnimationDuration:8.8f];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationRepeatAutoreverses:NO];
            [UIView setAnimationRepeatCount:9999999];
            CGRect frame = label.frame;
            frame.origin.x = -frame.origin.x-frame.size.width;
            label.frame = frame;
            [UIView commitAnimations];
            cell.clipsToBounds = YES;
        }else
        {
            [label.layer removeAllAnimations];
//            label.backgroundColor = [UIColor orangeColor];
        }
        
    }
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if ([item isKindOfClass:[CompanyTask class]]) {
        return 0;
    }
    if (item == nil) {
        return [_dataArray count];
    }
    SpreadClass *data = item;
    return [data.childArray count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    SpreadClass *data = item;
    if (item == nil) {
        return [_dataArray objectAtIndex:index];
    }
    return [data.childArray objectAtIndex:index];
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
    if ([item isKindOfClass:[SpreadClass class]]) {
        SpreadClass *sc = item;
        sc.isOPen = !sc.isOPen;
        cell.xialaImage.transform = sc.isOPen ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
    }
    if (treeNodeInfo.treeDepthLevel == 2) {
        [self turnToIdenController:treeNodeInfo];
    }
    if (treeNodeInfo.expanded == NO && treeNodeInfo.treeDepthLevel != 2) {
        [treeView reloadData];
    }
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (treeNodeInfo.treeDepthLevel == 0) {
            SpreadClass *class = item;
            for (int i=0; i<class.childArray.count; i++) {
                SpreadClass *class1 = class.childArray[i];
                for (int j=0; j<class1.childArray.count; j++) {
                    [self deleteDb:class1.childArray[j]];
                }
            }
            [_dataArray removeObject:item];
            
        }else if (treeNodeInfo.treeDepthLevel == 1)
        {
            SpreadClass *class = treeNodeInfo.parent.item;
            for (int i=0; i<((SpreadClass *)item).childArray.count; i++) {
                [self deleteDb:((SpreadClass *)item).childArray[i]];
            }
            [class.childArray removeObject:item];
            if (class.childArray.count == 0) {
                [_dataArray removeObject:class];
            }
        }else if (treeNodeInfo.treeDepthLevel == 2)
        {
            SpreadClass *class = treeNodeInfo.parent.item;
            [self deleteDb:item];
            [class.childArray removeObject:item];
            if (class.childArray.count == 0) {
                SpreadClass *classParent = treeNodeInfo.parent.parent.item;
                [classParent.childArray removeObject:class];
                if(classParent.childArray.count == 0)
                {
                    [_dataArray removeObject:classParent];
                }
            }
        }
        [treeView reloadData];
    }
}


- (void)backLastController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i=0; i<_dataArray.count; i++) {
        SpreadClass *spreadClass = _dataArray[i];
        if (spreadClass.isOPen) {
            NSMutableArray *array = [NSMutableArray array];
            for (int j=0; j<spreadClass.childArray.count; j++) {
                SpreadClass *spreadChild = spreadClass.childArray[j];
                if (spreadChild.isOPen) {
                    [array addObject:spreadChild.title];
                }
            }
            if (array.count == 0 && spreadClass.isOPen) {
                [array addObject:@""];
            }
            [dic setValue:array forKey:spreadClass.title];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:@"list_open"];
}

- (void)deleteDb:(CompanyTask *)task
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"dwid == %@ && kjmonth1 == %@ && kjmonth2 == %@ && kjyear1 == %@ && kjyear2 == %@ && ndid == %@ && dbID == %@ && dbName == %@ && ipAddress == %@ && xmmc == %@",task.company.dwid,task.company.kjmonth1,task.company.kjmonth2,task.company.kjyear1,task.company.kjyear2,task.company.ndid,task.company.dbID,task.company.dbName,task.company.ipAddress,task.company.xmmc];
    NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"ndid == %@ && dbID == %@ && ipAddress == %@",task.company.ndid,task.company.dbID,task.company.ipAddress];
    [EntityOneDao deleteWithEntityName:@"DetailLocal" predicate:pre1];
    [EntityOneDao deleteWithEntityName:@"Company" predicate:pre];
    
    
}

@end
