//
//  ChooseTaskController.m
//  VoucherCollection
//
//  Created by yongzhang on 15-2-9.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "ChooseTaskController.h"
#import "ParseChooseTaskData.h"
#import "NdidToTime.h"
#import "CompanyTask.h"
#import "CompanyInfoFromNetDao.h"
#import "EntityOneDao.h"
#import "CompanyDao.h"
@interface ChooseTaskController()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSArray *_databaseArray;
    NSString *_prjName;
    NSArray *_tempArr;
    BOOL _isFirst;
}
@end

@implementation ChooseTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.alpha = 0.0;
    [self initializeDataSource];
    [self initializeApperance];
}

- (void)dealloc
{
    
}

- (void)netTask:(NSString *)urlStr
{
    [super netTask:urlStr];
    [self.manager POST:self.url parameters:self.netDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endMBProgressHud];
        [_tableView headerEndRefreshing];
        [self parseData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endMBProgressHud];
        [self showAlertWithMessage:@"网络错误"];
        [_tableView headerEndRefreshing];
    }];
}

- (void)parseData:(id)responseObject
{
     _dataArray = [NSMutableArray arrayWithArray:[ParseChooseTaskData backNdidData:responseObject[@"data"]]];
    _tableView.alpha = 1.0;
    [_tableView reloadData];
    [CompanyInfoFromNetDao insertDataFromCompanys:responseObject[@"data"]];
}

- (void)initializeDataSource
{
    _prjName = _name;

    _databaseArray = [EntityOneDao readObjectWithEntityName:@"CompanyInfoFromNet" predicate:nil];
    if(_databaseArray.count == 0) {
        [self netTask:CHOOSE_COMPANY_URL];
        return;
    }
    _databaseArray = [ParseChooseTaskData backDictionArrayFromObj:_databaseArray];
    _dataArray = [NSMutableArray arrayWithArray:[ParseChooseTaskData backNdidData:_databaseArray]];
    _tableView.alpha = 1.0;
    [_tableView reloadData];
    
    
}

- (void)initializeApperance
{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(okBtnClick)];
    self.navigationItem.rightBarButtonItem = item;
    
    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.layer.borderWidth = 8;
    _searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    _searchBar.layer.cornerRadius = 5;
    _searchBar.delegate = self;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.returnKeyType = UIReturnKeySearch;
    __weak id weakSelf = self;
  
    [_tableView addHeaderWithCallback:^{
        [weakSelf netTask:CHOOSE_COMPANY_URL];
    }];
    _tableView.headerRefreshingText = @"正在刷新...";
}

- (void)okBtnClick
{
    _isFirst = YES;
    for (NdidToTime *ndid in _dataArray) {
        if (ndid.isSelected) {
            [self addTime:ndid];
            if (_isFirst) {
                [_delegate openTitle:ndid.duringTime];
                _isFirst = NO;
            }
        }else
        {
            for (CompanyTask *task in ndid.childArray) {
                if (task.isSelected) {
                    [self addTask:ndid companytask:task];
                    if (_isFirst) {
                        [_delegate openTitle:ndid.duringTime];
                        _isFirst = NO;
                    }
                }
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   __block NSInteger count = 0;
    count += _dataArray.count;
    [_dataArray enumerateObjectsUsingBlock:^(NdidToTime *obj, NSUInteger idx, BOOL *stop) {
        count += obj.childArray.count;
    }];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSDictionary *dic = [ParseChooseTaskData backPostionWithIndex:indexPath.row array:_dataArray];
    if([dic[@"isHeader"] isEqual:@1]) {
        NdidToTime *obj = _dataArray[[dic[@"position"] integerValue]];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        UILabel *label = (UILabel *)[cell viewWithTag:11];
        label.text = obj.duringTime;
        UIButton *button = (UIButton *)[cell viewWithTag:12];
        if([CompanyDao chargeHasWithNdid:obj]) {
            [button setImage:[UIImage imageNamed:@"completebtn"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"completebtn"] forState:UIControlStateSelected];
            button.userInteractionEnabled = NO;
            obj.isSelected = YES;
        } else
        {
            button.userInteractionEnabled = YES;
            [button setImage:[UIImage imageNamed:@"allcheck"] forState:UIControlStateNormal];
            button.selected = NO;
            [button setImage:[UIImage imageNamed:@"allcheck_on"] forState:UIControlStateSelected];
        }
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.selected = obj.isSelected;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        UILabel *label = (UILabel *)[cell viewWithTag:11];
        NdidToTime *obj = _dataArray[[dic[@"position1"] integerValue]];
        NSInteger position2 = [dic[@"position2"] integerValue] - 1;
        CompanyTask *task = obj.childArray[position2];
        label.text = task.xmcc;
        
        UIButton *button = (UIButton *)[cell viewWithTag:12];
        if([CompanyDao chargeHasWithNdid:obj.ndid dwid:task.dwid]) {
            [button setImage:[UIImage imageNamed:@"completebtn"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"completebtn"] forState:UIControlStateSelected];
            button.userInteractionEnabled = NO;
            task.isSelected = YES;
        } else
        {
            button.userInteractionEnabled = YES;
            [button setImage:[UIImage imageNamed:@"allcheck"] forState:UIControlStateNormal];
            button.selected = NO;
            [button setImage:[UIImage imageNamed:@"allcheck_on"] forState:UIControlStateSelected];
        }
        
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.selected = task.isSelected;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_dataArray.count == 0)
        return nil;
    //先判断是否已经添加
    NSArray *array =[CompanyDao readDataWithIp:self.selectState.ipAddress dbID:self.selectState.dbGuid];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 10, 200, 25)];
    titleLabel.text = _prjName;
    [mainView addSubview:titleLabel];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.bounds = CGRectMake(0, 0, 45, 25);
    addButton.center = CGPointMake(37, 25);
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:11];
//    [addButton setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
    addButton.layer.cornerRadius = 3;
    NSInteger task_count = 0;
    NSInteger count = 0;
    BOOL selected = NO;
    for (NdidToTime *ndid in _dataArray) {
        for (CompanyTask *task in ndid.childArray) {
            count++;
            for (Company *com in array) {
                if ([com.dwid integerValue] == [task.dwid integerValue] && [com.ndid integerValue] == [task.ndid integerValue]) {
                    task_count++;
//                    break;
                }
            }
            
        }
    }
    if (_tempArr.count > 0) {
        if (task_count == _dataArray.count) {
            selected = YES;
        }
    }else
    {
        if (count == array.count) {
            selected = YES;
        }
    }
    

    
    if(selected) {
//        [addButton setTitle:@"已添加" forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"completebtn"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"completebtn"] forState:UIControlStateSelected];
        addButton.selected = YES;
        addButton.userInteractionEnabled = NO;
    } else {
        addButton.userInteractionEnabled = YES;
        [addButton setImage:[UIImage imageNamed:@"allcheck"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"allcheck_on"] forState:UIControlStateSelected];
        addButton.selected = NO;
//        [addButton setTitle:@"添加" forState:UIControlStateNormal];
    }
    NSInteger tempCount = 0;
    for (NdidToTime *ndid in _dataArray) {
        for (CompanyTask *task in ndid.childArray) {
            if (task.isSelected) {
                BOOL temp = YES;
                for (Company *com in array) {
                    if ([com.dwid integerValue] == [task.dwid integerValue] && [com.ndid integerValue] == [task.ndid integerValue]) {
                        temp = NO;
                        break;
                    }
                }
                if (temp) {
                    tempCount++;
                }
            }
            
        }
    }

    
    if (tempCount + task_count == count) {
        addButton.selected = YES;
    }
    
    [addButton addTarget:self action:@selector(addAll:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:addButton];
    addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = COLOR4(220, 220, 220, 1);
    [mainView addSubview:lineView];
    
    return mainView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_dataArray.count == 0)
        return 0.01;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//设置表头跟着滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = 50; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    [_searchBar resignFirstResponder];
}
- (IBAction)add:(UIButton *)sender {
    NSIndexPath *indexPath;
    UITableViewCell *cell;
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0 ) {
        cell = (UITableViewCell *)[[sender superview] superview];
    } else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    indexPath = [_tableView indexPathForCell:cell];
    
    NSDictionary *dic = [ParseChooseTaskData backPostionWithIndex:indexPath.row array:_dataArray];
    sender.selected = !sender.selected;
    if ([cell.reuseIdentifier isEqualToString:@"cell1"]) {
        NSLog(@"%@",dic[@"position"]);
        NdidToTime *obj = _dataArray[[dic[@"position"] integerValue]];
        obj.isSelected = sender.selected;
        for (CompanyTask *task in obj.childArray) {
            task.isSelected = obj.isSelected;
        }
        [_tableView reloadData];
//        [self addTime:[dic[@"position"] integerValue]];
        
    } else {
        NSLog(@"section:\nposition1:%@\nposition2:%@ - 1",dic[@"position1"],dic[@"position2"]);
//        [self addTask:[dic[@"position1"] integerValue] postion:[dic[@"position2"] integerValue ]- 1];
        
        NdidToTime *obj = _dataArray[[dic[@"position1"] integerValue]];
        CompanyTask *task = obj.childArray[[dic[@"position2"] integerValue ]- 1];
        task.isSelected = sender.selected;
        NSInteger count = 0;
        for (CompanyTask *task in obj.childArray) {
            if (task.isSelected) {
                count++;
            }
        }
        if (count == obj.childArray.count) {
            obj.isSelected = YES;
        }else
        {
            obj.isSelected = NO;
        }
        [_tableView reloadData];
    }
    [_tableView reloadData];
//    UIButton *button = sender;
//    [button setTitle:@"已添加" forState:UIControlStateNormal];
    
}

- (void)addAll:(UIButton *)sender;
{
    sender.selected = !sender.selected;
    for (NdidToTime *ndid in _dataArray) {
        ndid.isSelected = sender.isSelected;
        for (CompanyTask *task in ndid.childArray) {
            task.isSelected = sender.isSelected;
        }
    }
    [_tableView reloadData];
//    [sender setTitle:@"已添加" forState:UIControlStateNormal];
//    [CompanyDao insertData:_dataArray];
}

- (void)addTime:(NdidToTime *)time
{
//    NdidToTime *obj = _dataArray[time];
    NSArray *array = @[time];
    [CompanyDao insertData:array];
}

- (void)addTask:(NdidToTime *)ndid companytask:(CompanyTask *)companytask
{
    NdidToTime *obj = [[NdidToTime alloc] init];
    NdidToTime *tempObj = ndid;
    obj.ndid = tempObj.ndid;
    obj.duringTime = tempObj.duringTime;
    obj.childArray = [NSMutableArray arrayWithArray:tempObj.childArray];
    obj.company = tempObj.company;
    
    CompanyTask *task = companytask;
    [obj.childArray removeAllObjects];
    [obj.childArray addObject:task];
    NSArray *array = @[obj];
    [CompanyDao insertData:array];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (_tempArr.count == 0 && _dataArray.count != 0) {
        _tempArr = [self copyDataArr];
    }
    [self search:searchText];
}

- (NSArray *)copyDataArr
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NdidToTime *ndid in _dataArray) {
        NdidToTime *obj = [[NdidToTime alloc] init];
        obj.ndid = ndid.ndid;
        obj.duringTime = ndid.duringTime;
        obj.childArray = [NSMutableArray array];
        for (CompanyTask *task in ndid.childArray) {
            [obj.childArray addObject:task];
        }
        obj.company = ndid.company;
        obj.isSelected = ndid.isSelected;
        [arr addObject:obj];
    }
    return arr;
}

- (void)search:(NSString *)str
{
    if (str.length == 0) {
        _dataArray = [NSMutableArray arrayWithArray:_tempArr];
        _tempArr = nil;
        [_tableView reloadData];
        [self.view endEditing:YES];
    }else
    {
        if([_prjName rangeOfString:str].length)
            return;
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"xmcc CONTAINS %@",str];
        for (int i=0; i<_dataArray.count; i++) {
            NdidToTime *ndid = _dataArray[i];
            if ([ndid.duringTime rangeOfString:str].length) {
                continue;
            }
            [ndid.childArray filterUsingPredicate:pre];
            NSInteger count= 0;
            for (CompanyTask *task in ndid.childArray) {
                if (task.isSelected) {
                    count ++;
                }
            }
            if (count == ndid.childArray.count) {
                ndid.isSelected = YES;
            }
            if (ndid.childArray.count == 0) {
                [_dataArray removeObject:ndid];
                i--;
            }
        }
        [_tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self search:searchBar.text];
    [searchBar resignFirstResponder];
}


@end
