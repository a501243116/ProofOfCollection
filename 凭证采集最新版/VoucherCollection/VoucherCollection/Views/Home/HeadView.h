//
//  HeadView.h
//  TestThreeAgreeTableView
//
//  Created by yongzhang on 15-1-27.
//  Copyright (c) 2015年 yongzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpreadClass;

@protocol HeadViewDelegate <NSObject>

@optional
- (void)clickHeadView;

@end

@interface HeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) SpreadClass *sc;

@property (nonatomic, weak) id<HeadViewDelegate> delegate;

+ (instancetype)headViewWithTableView:(UITableView *)tableView;


@end
