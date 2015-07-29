//
//  CheckStateController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-20.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "CheckStateController.h"
#import "ExamineDao.h"
#import "Examine.h"
#import "EntityOneDao.h"
#import "ExamineIdenDao.h"
#import "ExamineIden.h"
#import "SettingPlistHandler.h"

@interface CheckStateController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_stateArray;
    CGFloat _tableHeight;
    BOOL _hasData;//用于判断是否已经保存过iden
    SelectState *_selectState;
    BOOL _selectedTurn;//是否在设置里面点击了全选进入下一个凭证
}
@end

@implementation CheckStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeApperance];
}

- (void)dealloc
{
}

- (void)setPhoto:(Photos *)photo
{
    _photo = photo;
    [self initializeDataSource];
}

- (void)initializeDataSource
{
    _hasData = NO;
    NSDictionary *dic = [SettingPlistHandler getSettingData];
    if([dic[@"isTurn"] isEqual:@1]) {
        _selectedTurn = YES;
    } else {
        _selectedTurn = NO;
    }
    
    _selectState = [SelectState shareInstance];

    _dataArray = [NSMutableArray new];
    NSArray *array = [ExamineIdenDao readDataFromIden:_photo.iden ipAddress:_selectState.nowIp];
    if (array.count > 0) {
        _hasData = YES;
        for(ExamineIden *eIden in array) {
            NSArray *resultArray = [ExamineDao readDataWith:_photo.dwid ndid:_photo.ndid parId:eIden.parId];
            Examine *examine = resultArray[0];
            [_dataArray addObject:examine];
        }
    } else {
    

    [_dataArray setArray:[ExamineDao readDataWith:_photo.dwid ndid:_photo.ndid]];
    }
    
    _stateArray = [NSMutableArray new];
    for (int i = 0; i < _dataArray.count; i ++) {
        if(_hasData) {
            ExamineIden *eIden = array[i];
            [_stateArray addObject:eIden.hasCheck];
            
        } else {
        [_stateArray addObject:@0];
        }
    }
    
}

- (void)initializeApperance
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //保存按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
    saveButton.backgroundColor = COLOR4(50, 200, 100, 1);
    [saveButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:0.9];
    [saveButton autoSetDimension:ALDimensionHeight toSize:50];
    [saveButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    _tableHeight = 70 + _dataArray.count * 44;
    [saveButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [saveButton layoutIfNeeded];
    saveButton.layer.cornerRadius = 5;
    [saveButton addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)check
{
    NSNumber *iden = _photo.iden;
    for(int i = 0;i < _dataArray.count; i++) {
        Examine *examine = _dataArray[i];
        NSString *parId = examine.parId;
        NSNumber *hasCheck = _stateArray[i];
        NSDictionary *dic = @{@"iden":iden,@"parId":parId,@"hasCheck":hasCheck,@"parname":examine.parName,@"ipAddress":_selectState.nowIp};
        if(_hasData) {
            [ExamineIdenDao mofifyDataWithNewData:dic ipAddress:_selectState.nowIp];
        } else {
        [ExamineIdenDao inserDataWithDic:dic entityName:@"ExamineIden"];
        }
    }
    [self showAlertWithMessage:@"完成"];

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
    Examine *examine = _dataArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCheckCell"];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:22];
    contentLabel.text = examine.parName;
    
    UIButton *button = (UIButton *)[cell viewWithTag:21];
    if ([_stateArray[indexPath.row] isEqual:@0]) {
        button.selected = NO;
    } else {
        button.selected = YES;
    }
    return cell;
}

- (IBAction)chooseAll:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if(button.selected) {
        for(int i = 0;i < _stateArray.count;i ++) {
            _stateArray[i] = @1;
        }
    } else {
        for(int i = 0;i < _stateArray.count;i ++) {
            _stateArray[i] = @0;
        }
    }
    [_tableView reloadData];
    
    //如果选择了进入下一条
    if(_selectedTurn) {
        if(_fromHome) {
            return;
        }
        button.selected = NO;
        [self check];
        if(_delegate && [_delegate respondsToSelector:@selector(clickAll)]) {
            [_delegate clickAll];
        }
    }
}
- (IBAction)clickOne:(id)sender {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)[cell viewWithTag:21];
    button.selected = !button.selected;
    _stateArray[indexPath.row] = button.selected?@1:@0;
}

@end
