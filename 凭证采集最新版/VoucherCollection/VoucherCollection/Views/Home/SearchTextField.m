//
//  SearchTextField.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-11.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "SearchTextField.h"

@implementation SearchTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, 30, 30);
        button.center = CGPointMake(18, 19);
        [button setImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 45, bounds.origin.y + 5, bounds.size.width - 10 , bounds.size.height - 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 45, bounds.origin.y + 5, bounds.size.width - 10 , bounds.size.height - 10);
}

- (void)search
{
    if(self.selfDelegate && [self.selfDelegate respondsToSelector:@selector(searchButtonPressed)] ) {
        [self.selfDelegate searchButtonPressed];
        
    }
}

@end
