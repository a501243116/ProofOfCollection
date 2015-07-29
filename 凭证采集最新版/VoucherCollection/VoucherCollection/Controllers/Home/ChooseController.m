//
//  ChooseController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-13.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "ChooseController.h"
#import "CostDetailInfo.h"
#import "ChooseManuscriptController.h"
#import "DetailLocalDao.h"
#import "ChooseTableViewCell.h"

@interface ChooseController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *_cyDataDic;
    UIView *_rightView;
    UISegmentedControl *seg;
    ChooseManuscriptController *manuscriptController;
    UIView *_newRightView;
}

@end

@implementation ChooseController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.bounds = CGRectMake(0, 0, 60, 30);
    [chooseButton setTitle:@"完成" forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:chooseButton];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)done:(UIBarButtonItem *)item
{
    for (CostDetailInfo *info in _dataArray) {
        [DetailLocalDao updateDetailLocal:info];
    }
    [_delegate backController];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeApperance];
}

- (void)initializeDataSource
{
    _dataArray = [NSMutableArray array];
    _cyDataDic = [NSMutableDictionary dictionary];
    NSArray *array = [DetailLocalDao readAllDataWith:self.selectState.ipAddress company:self.selectState.companyName ndId:self.selectState.ndid dbID:self.selectState.sdbGuid fetch:0 limit:NSIntegerMax];
    _allButton.selected = YES;
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
        info.isSelected = detaiLocal.isSelected;
        NSLog(@"%@",info.bh);
        [_dataArray addObject:info];
        
        if ([info.isSelected integerValue] == 1) {
            _allButton.selected = NO;
        }
        
        [_cyDataDic setValue:@YES forKey:info.cyfaname];
    }
    
    for (CostDetailInfo *info in _dataArray) {
        if ([info.isSelected integerValue] == 1) {
            [_cyDataDic setValue:@NO forKey:info.cyfaname];
        }
    }
    
    [_tableView1 reloadData];
}

- (void)initializeApperance
{
    self.title = @"被审计单位";
    
    seg = [[UISegmentedControl alloc] initForAutoLayout];
    [_topView addSubview:seg];
    [seg autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_topView withMultiplier:0.7];
    [seg autoCenterInSuperview];
    [seg insertSegmentWithTitle:@"手动筛选" atIndex:0 animated:YES];
    [seg insertSegmentWithTitle:@"按底稿筛选" atIndex:1 animated:YES];
    [seg addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    seg.selectedSegmentIndex = 0;
    
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    
    //初始化底稿筛选视图
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    manuscriptController = [storyboard instantiateViewControllerWithIdentifier:@"chooseManuscript"];
    [self addChildViewController:manuscriptController];
    manuscriptController.dataArray = _dataArray;
    manuscriptController.cyDataDic = _cyDataDic;
    
    _newRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 114)];
    _newRightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_newRightView];
    
    [_newRightView addSubview:manuscriptController.view];
    _newRightView.hidden = YES;
}

//切换筛选视图
- (void)changeView:(UISegmentedControl *)seg1
{
    if(seg.selectedSegmentIndex == 0) {
        _allButton.selected = YES;
        for (CostDetailInfo *info in _dataArray) {
            if ([info.isSelected integerValue] == 1) {
                _allButton.selected = NO;
                break;
            }
        }
        [_tableView1 reloadData];
        _newRightView.hidden = YES;
    } else {
        _newRightView.hidden = NO;
    }
}

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
    ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell1"];
    CostDetailInfo *info = _dataArray[indexPath.row];
    
//    UIButton *button = (UIButton *)[cell viewWithTag:14];
    
    UILabel *titlelabel = (UILabel *)[cell viewWithTag:11];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:12];
    UILabel *moneyLabel = (UILabel *)[cell viewWithTag:13];
    
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@ %@%@",info.jzsj,info.pzzl,info.pzbh];
    [title replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, title.length)];
    titlelabel.text = title;
    contentLabel.text = [NSString stringWithFormat:@"摘要:%@",info.sm];
    
    char c = [info.dffse characterAtIndex:0];
    if(c == 48) {
        moneyLabel.text = [NSString stringWithFormat:@"贷方发生额:￥%@",info.jffse];
    } else {
        moneyLabel.text = [NSString stringWithFormat:@"借方发生额:￥%@",info.dffse];
    }

    cell.chooseBtn.tag = indexPath.row + 1000;
    //设置button的选中状态
    if([info.isSelected integerValue] == 0) {
        cell.chooseBtn.selected = YES;
    } else {
        cell.chooseBtn.selected = NO;
    }
    [cell.chooseBtn addTarget:self action:@selector(selectOne:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//设置全选
- (IBAction)selectAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    for (CostDetailInfo *info in _dataArray) {
        if (sender.selected) {
            info.isSelected = @0;
        }else
            info.isSelected = @1;
    }
    [_tableView1 reloadData];
}

- (void)selectOne:(UIButton *)sender {
    CostDetailInfo *info = _dataArray[sender.tag - 1000];
    sender.selected = !sender.selected;
    if (sender.selected) {
        info.isSelected = @0;
    }else
        info.isSelected = @1;
    NSInteger count = 0;
    for (CostDetailInfo *info in _dataArray) {
        if ([info.isSelected integerValue] == 0) {
            count++;
        }
    }
    if (count == _dataArray.count) {
        _allButton.selected = YES;
    }else
        _allButton.selected = NO;
//    _allButton.selected = NO;
//    UIButton *button = sender;
//    button.selected = !button.selected;
//    NSIndexPath *indexPath;
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//   indexPath = [_tableView1 indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
//    } else {
//        indexPath = [_tableView1 indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];
//    }
//    if(button.selected) {
//        _selectedArray[indexPath.row] = @1;
//    } else {
//        _selectedArray[indexPath.row] = @0;
//    }
}
@end
