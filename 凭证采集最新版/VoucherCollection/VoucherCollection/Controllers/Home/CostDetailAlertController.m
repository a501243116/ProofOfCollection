//
//  CostDetailAlertController.m
//  VoucherCollection
//
//  Created by yongzhang on 15-2-12.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "CostDetailAlertController.h"
#import "NSMutableAttributedString+string.h"
#import "HomePhotoController.h"

@interface CostDetailAlertController()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation CostDetailAlertController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeApperance];
    [self initdata];
}

- (void)initializeApperance
{
    
    //为视图添加左滑右滑手势
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftGesture];
    [self.view addGestureRecognizer:rightGesture];
    
}

- (void)swipeView:(UISwipeGestureRecognizer *)gesture
{
    
    if(_delegate && [_delegate respondsToSelector:@selector(backLeftOrRightSwipe:)]) {
        [_delegate backLeftOrRightSwipe:gesture.direction];
    }
}

- (void)setData:(IdenAlertData *)data
{
    _data = data;
    _timeLabel.text = data.time;
    _kindLabel.text = data.kind;
    _codeLabel.text = [NSString stringWithFormat:@"%@",data.idenCode];
    [_tableView reloadData];
    

}


- (void)initdata
{
    CGFloat jf = 0;
    CGFloat df = 0;
    for (CostDetailInfo *info in _data.tableData) {
        char c = [info.dffse characterAtIndex:0];
        if (c == 48) {
            df += [info.jffse floatValue];
        }else
        {
            jf += [info.dffse floatValue];
        }
    }
    
    NSNumber *jfnum = [NSNumber numberWithFloat:jf];
    NSNumber *dfnum = [NSNumber numberWithFloat:df];
    NSNumberFormatter *formater=[[NSNumberFormatter alloc] init];
    [formater setNumberStyle: NSNumberFormatterCurrencyStyle];
    _jfTotal.text = [NSString stringWithFormat:@"借方合计:%@",[formater stringFromNumber:jfnum]];
    _dfTotal.text = [NSString stringWithFormat:@"贷方合计:%@",[formater stringFromNumber:dfnum]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *kmbh = (UILabel *)[cell viewWithTag:10];
    UILabel *kmmc = (UILabel *)[cell viewWithTag:11];
    UILabel *fse = (UILabel *)[cell viewWithTag:12];
    UILabel *zy = (UILabel *)[cell viewWithTag:13];
    kmbh.textColor = [UIColor blackColor];
    kmmc.textColor = [UIColor blackColor];
    fse.textColor = [UIColor blackColor];
    zy.textColor = [UIColor blackColor];
    
    CostDetailInfo *info = _data.tableData[indexPath.row];
    
    char c = [info.dffse characterAtIndex:0];
    UIColor *grayColor = [UIColor grayColor];
    if(c == 48) {
        
        NSString *kmbhStr = [NSString stringWithFormat:@"%@[科目编号]",info.kmbh];
        kmbh.attributedText = [NSMutableAttributedString attributedColorString:kmbhStr color:grayColor range:NSMakeRange(kmbhStr.length - 6, 6)];
        
        
        
        NSString *kmmcStr = [NSString stringWithFormat:@"%@[科目名称]",info.kmmc];
        kmmc.attributedText = [NSMutableAttributedString attributedColorString:kmmcStr color:grayColor range:NSMakeRange(kmmcStr.length - 6, 6)];
        
        NSNumber *num = [NSNumber numberWithFloat:[info.jffse floatValue]];
        NSNumberFormatter *formater=[[NSNumberFormatter alloc] init];
        [formater setNumberStyle: NSNumberFormatterCurrencyStyle];
        
        NSString *fseStr = [NSString stringWithFormat:@"%@[贷方发生额]",[formater stringFromNumber:num]];
        fse.attributedText = [NSMutableAttributedString attributedColorString:fseStr color:grayColor range:NSMakeRange(fseStr.length - 7, 7)];
        
        NSString *zyStr = [NSString stringWithFormat:@"%@[摘要]",info.sm];
        zy.attributedText = [NSMutableAttributedString attributedColorString:zyStr color:grayColor range:NSMakeRange(zyStr.length - 4, 4)];
        
        
        kmbh.textAlignment = NSTextAlignmentRight;
        kmmc.textAlignment = NSTextAlignmentRight;
        fse.textAlignment = NSTextAlignmentRight;
        zy.textAlignment = NSTextAlignmentRight;
    } else {
        
        NSString *kmbhStr = [NSString stringWithFormat:@"[科目编号]%@",info.kmbh];
        kmbh.attributedText = [NSMutableAttributedString attributedColorString:kmbhStr color:grayColor range:NSMakeRange(0, 6)];
        
        NSString *kmmcStr = [NSString stringWithFormat:@"[科目名称]%@",info.kmmc];
        kmmc.attributedText = [NSMutableAttributedString attributedColorString:kmmcStr color:grayColor range:NSMakeRange(0, 6)];
        
        NSNumber *num = [NSNumber numberWithFloat:[info.dffse floatValue]];
        NSNumberFormatter *formater=[[NSNumberFormatter alloc] init];
        [formater setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *fseStr = [NSString stringWithFormat:@"[借方发生额]%@",[formater stringFromNumber:num]];
        fse.attributedText = [NSMutableAttributedString attributedColorString:fseStr color:grayColor range:NSMakeRange(0, 7)];
        
        NSString *zyStr = [NSString stringWithFormat:@"[摘要]%@",info.sm];
        zy.attributedText = [NSMutableAttributedString attributedColorString:zyStr color:grayColor range:NSMakeRange(0, 4)];
        
        kmbh.textAlignment = NSTextAlignmentLeft;
        kmmc.textAlignment = NSTextAlignmentLeft;
        fse.textAlignment = NSTextAlignmentLeft;
        zy.textAlignment = NSTextAlignmentLeft;
    }
    
    if ([info.iden integerValue] == [_info.iden integerValue]) {
        kmbh.textColor = [UIColor blueColor];
        kmmc.textColor = [UIColor blueColor];
        fse.textColor = [UIColor blueColor];
        zy.textColor = [UIColor blueColor];
    }
    
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}


- (IBAction)takePhoto:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomePhotoController *controller = [storyboard instantiateViewControllerWithIdentifier:@"homePhoto"];
    [self.navigationController pushViewController:controller animated:YES];
    controller.delegate = self;
}

@end
