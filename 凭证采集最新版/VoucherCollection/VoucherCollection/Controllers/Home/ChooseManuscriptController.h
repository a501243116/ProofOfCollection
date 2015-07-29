//
//  ChooseManuscriptController.h
//  VoucherCollection
//
//  Created by yongzhang on 14-11-14.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseManuscriptController : UIViewController

@property (nonatomic,strong) NSMutableArray *dataArray;
 @property (nonatomic,strong) NSMutableDictionary *cyDataDic;//选中的数组
@property (strong, nonatomic) IBOutlet UIButton *buttonAll;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clickAll2:(id)sender;

@end
