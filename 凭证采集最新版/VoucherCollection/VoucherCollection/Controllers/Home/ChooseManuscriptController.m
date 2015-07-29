//
//  ChooseManuscriptController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-14.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "ChooseManuscriptController.h"
#import "CostDetailParse.h"
#import "CostDetailInfo.h"

@interface ChooseManuscriptController ()<UITableViewDataSource,UITableViewDelegate>
{
//    NSMutableArray *_selectedArray;//选中的数组
//    NSArray *_datas;//解析出来的数据
}
@end

@implementation ChooseManuscriptController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self intialzizeApperance];
}

- (void)initializeDataSource
{
    _buttonAll.selected = YES;
    for (NSString *key in _cyDataDic) {
        if (![_cyDataDic[key] boolValue]) {
            _buttonAll.selected = NO;
        }
    }
    
}

- (void)intialzizeApperance
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cyDataDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseM"];
    
    UIButton *button = (UIButton *)[cell viewWithTag:15];
    UILabel *label = (UILabel *)[cell viewWithTag:12];
    
    label.text = _cyDataDic.allKeys[indexPath.row];
    
    //设置button的选中状态
    button.selected = [_cyDataDic[label.text] boolValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)[cell viewWithTag:15];
    UILabel *label = (UILabel *)[cell viewWithTag:12];
    button.selected = !button.selected;
    [_cyDataDic setValue:@(button.selected) forKey:label.text];
    [self initializeDataSource];
    for (CostDetailInfo *info in _dataArray) {
        if ([info.cyfaname isEqualToString:label.text]) {
            if (button.selected) {
                info.isSelected = @0;
            }else
                info.isSelected = @1;
        }
    }

    
}

- (IBAction)clickAll2:(id)sender {
    UIButton *button = sender;
    button.selected = !button.selected;
    for (int i=0; i<_cyDataDic.allKeys.count; i++) {
        [_cyDataDic setValue:@(button.selected) forKey:_cyDataDic.allKeys[i]];
    }
    for (CostDetailInfo *info in _dataArray) {
        if (button.selected) {
            info.isSelected = @0;
        }else
            info.isSelected = @1;
    }
    [_tableView reloadData];
}
@end
