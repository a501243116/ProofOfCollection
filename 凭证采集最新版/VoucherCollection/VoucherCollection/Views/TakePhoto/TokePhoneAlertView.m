//
//  TokePhoneAlertView.m
//  VoucherCollection
//
//  Created by yongzhang on 14-12-15.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "TokePhoneAlertView.h"

@interface TokePhoneAlertView()
{
    UIView *_selfAlertView;
}


@end

@implementation TokePhoneAlertView

- (id)initWithCompany:(NSString *)company time:(NSString *)time number:(NSString *)number
{
    self = [self init];
    if(self) {
            [self initlizeApperance];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.company = company;
        self.time = time;
        self.number = number;
    }
    return self;
    
}

- (void)initlizeApperance
{
    self.backgroundColor = COLOR4(80, 80, 80,0.2);
    _selfAlertView = [[UIView alloc] initForAutoLayout];
    [self addSubview:_selfAlertView];
    [_selfAlertView autoCenterInSuperview];
    [_selfAlertView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:0.9];
    [_selfAlertView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:_selfAlertView withMultiplier:0.66];
    _selfAlertView.backgroundColor = [UIColor whiteColor];
    [_selfAlertView layoutIfNeeded];
    _selfAlertView.layer.cornerRadius = 5;
    
    //提示
    UILabel *tipLabel = [[UILabel alloc] initForAutoLayout];
    [_selfAlertView addSubview:tipLabel];
    [tipLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [tipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [tipLabel autoSetDimensionsToSize:CGSizeMake(60, 35)];
    tipLabel.font = [UIFont systemFontOfSize:20];
    tipLabel.text = @"提示";
    
    //横线
    UIView *firstLine = [[UIView alloc] initForAutoLayout];
    [_selfAlertView addSubview:firstLine];
    firstLine.backgroundColor = COLOR4(0 , 130, 170, 1);
    [firstLine autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_selfAlertView];
    [firstLine autoSetDimension:ALDimensionHeight toSize:2];
    [firstLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [firstLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipLabel withOffset:5];
    
    //当前期间
    UILabel *timeLabel = [[UILabel alloc] initForAutoLayout];
    [_selfAlertView addSubview:timeLabel];
    [timeLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [timeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [timeLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_selfAlertView withMultiplier:0.8];
    [timeLabel autoSetDimension:ALDimensionHeight toSize:30];
    timeLabel.text = @"当前期间:";
    timeLabel.font = [UIFont systemFontOfSize:18];
    timeLabel.textColor = COLOR4(70, 70, 70, 1);
    timeLabel.tag = 12;
    
    //当前项目
    UILabel *companyLabel = [[UILabel alloc] initForAutoLayout];
    [_selfAlertView addSubview:companyLabel];
    [companyLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:timeLabel withOffset:-2];
    [companyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [companyLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_selfAlertView withMultiplier:0.8];
    [companyLabel autoSetDimension:ALDimensionHeight toSize:30];
    companyLabel.text = @"当前项目:";
    companyLabel.font = [UIFont systemFontOfSize: 18];
    companyLabel.textColor = COLOR4(70, 70, 70, 1);
    companyLabel.tag = 11;
    
    //拍照凭证
    UILabel *numberLabel = [[UILabel alloc] initForAutoLayout];
    [_selfAlertView addSubview:numberLabel];
    [numberLabel autoPinEdge:ALEdgeTop  toEdge:ALEdgeBottom ofView:timeLabel withOffset:2];
    [numberLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [numberLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_selfAlertView withMultiplier:0.8];
    [numberLabel autoSetDimension:ALDimensionHeight toSize:30];
    numberLabel.text = @"拍照凭证:";
    numberLabel.font = [UIFont systemFontOfSize: 18];
    numberLabel.textColor = COLOR4(70, 70, 70, 1);
    numberLabel.tag = 13;
    
    //第二条横线
    UIView *lineView2 = [[UIView alloc] initForAutoLayout];
    [_selfAlertView addSubview:lineView2];
    lineView2.backgroundColor = COLOR4(220 , 220, 220, 1);
    [lineView2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_selfAlertView];
    [lineView2 autoSetDimension:ALDimensionHeight toSize:1];
    [lineView2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [lineView2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_selfAlertView withOffset:-45];
    
    //竖线
    UIView *lineView3 = [[UIView alloc] initForAutoLayout];
    [_selfAlertView addSubview:lineView3];
    lineView3.backgroundColor = COLOR4(220, 220, 220, 1);
    [lineView3 autoSetDimensionsToSize:CGSizeMake(1, 50)];
    [lineView3 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [lineView3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_selfAlertView withOffset:-45];
    
    //更换项目
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selfAlertView addSubview:changeButton];
    [changeButton setTitle:@"更换项目" forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [changeButton autoSetDimension:ALDimensionHeight toSize:45];
    [changeButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_selfAlertView withMultiplier:0.5];
    [changeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [changeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [changeButton addTarget:self action:@selector(changeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //进入拍照
    UIButton *takePhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selfAlertView addSubview:takePhoneButton];
    [takePhoneButton setTitle:@"进入拍照" forState:UIControlStateNormal];
    [takePhoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    takePhoneButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [takePhoneButton autoSetDimension:ALDimensionHeight toSize:45];
    [takePhoneButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_selfAlertView withMultiplier:0.5];
    [takePhoneButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [takePhoneButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [takePhoneButton addTarget:self action:@selector(takePhoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

- (void)changeButtonPressed:(UIButton *)sender
{
    [self hide];
    if (_delegate && [_delegate respondsToSelector:@selector(changeButtonPressed)]) {
        [_delegate changeButtonPressed];
    }
}

- (void)takePhoneButtonPressed:(UIButton *)sender
{
    [self hide];
    if(_delegate && [_delegate respondsToSelector:@selector(takePhoneButtonPressed)]) {
        [_delegate takePhoneButtonPressed];
    }
}

- (void)setCompany:(NSString *)company
{
    _company = company;
    UILabel *label = (UILabel *)[_selfAlertView viewWithTag:11];
    label.text = company;
}

- (void)setTime:(NSString *)time
{
    _time = time;
    UILabel *label = (UILabel *)[_selfAlertView viewWithTag:12];
    label.text = time;
}

- (void)setNumber:(NSString *)number
{
    _number = number;
    UILabel *label = (UILabel *)[_selfAlertView viewWithTag:13];
    label.text = number;
}

@end
