//
//  NoServerView.m
//  VoucherCollection
//
//  Created by yongzhang on 15-1-19.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "NoServerView.h"

@implementation NoServerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeApperance];
    }
    return self;
}

- (void)initializeApperance
{
    CGFloat height = self.bounds.size.height;
    
//    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, height);
//    self.center = CGPointMake(SCREEN_WIDTH / 2, height / 2);
//    self.backgroundColor = [UIColor redColor];
    //等待图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.center = CGPointMake(SCREEN_WIDTH / 2, height * 0.25);
    imageView.image = [UIImage imageNamed:@"wrong.png"];
    [self addSubview:imageView];
    
    //提示文字
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _tipLabel.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(imageView.frame) + 40);
//    _tipLabel.text = @"没有搜索到服务器,请确认相关服务是否";
    _tipLabel.numberOfLines = 0;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_tipLabel];
    
//    UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
//    tipLabel2.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(imageView.frame) + 60);
//    tipLabel2.text = @"启动,并下拉刷新";
//    tipLabel2.textAlignment = NSTextAlignmentCenter;
//    tipLabel2.textColor = [UIColor darkGrayColor];
//    [self addSubview:tipLabel2];
    
//    //刷新按钮
//    UIButton *refreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    refreButton.bounds = CGRectMake(0, 0, 0.4 * SCREEN_WIDTH, 0.12 * SCREEN_WIDTH);
//    refreButton.center = CGPointMake(0.25 * SCREEN_WIDTH, CGRectGetMaxY(tipLabel2.frame) + 0.12 * SCREEN_WIDTH);
//    refreButton.backgroundColor = COLOR4(35, 102, 184, 1);
//    refreButton.layer.cornerRadius = 5;
//    [refreButton addTarget:self action:@selector(refreshButtonPre) forControlEvents:UIControlEventTouchUpInside];
//
//    [self addSubview:refreButton];
//    
//    //左边的图标
//    UIImageView *refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    refreshImageView.center = CGPointMake(25, 0.12 * SCREEN_WIDTH / 2);
//    refreshImageView.image = [UIImage imageNamed:@"refresh.png"];
//    [refreButton addSubview:refreshImageView];
//    
//    //左边的文字
//    UILabel *refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
//    refreshLabel.center = CGPointMake(0.25 * SCREEN_WIDTH,0.06 * SCREEN_WIDTH);
//    refreshLabel.text = @"刷新";
//    refreshLabel.textColor = [UIColor whiteColor];
//    refreshLabel.textAlignment = NSTextAlignmentCenter;
//    refreshLabel.font = [UIFont systemFontOfSize:13];
//    [refreButton addSubview:refreshLabel];
//    
//    //输入按钮
//    UIButton *inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    inputButton.bounds = CGRectMake(0, 0, 0.4 * SCREEN_WIDTH, 0.12 * SCREEN_WIDTH);
//    inputButton.center = CGPointMake(0.75 * SCREEN_WIDTH, CGRectGetMaxY(tipLabel2.frame) + 0.12 * SCREEN_WIDTH);
//    inputButton.backgroundColor = COLOR4(35, 184, 101, 1);
//    inputButton.layer.cornerRadius = 5;
//    [inputButton addTarget:self action:@selector(input) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:inputButton];
//    
//    //左边的图标
//    UIImageView *inputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    inputImageView.center = CGPointMake(25, 0.12 * SCREEN_WIDTH / 2);
//    inputImageView.image = [UIImage imageNamed:@"inputbtn.png"];
//    [inputButton addSubview:inputImageView];
//    
//    //左边的文字
//    UILabel *inputLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
//    inputLabel.center = CGPointMake(0.25 * SCREEN_WIDTH,0.06 * SCREEN_WIDTH);
//    inputLabel.text = @"手动输入";
//    inputLabel.textColor = [UIColor whiteColor];
//    inputLabel.textAlignment = NSTextAlignmentCenter;
//    inputLabel.font = [UIFont systemFontOfSize:13];
//    [inputButton addSubview:inputLabel];
}

- (void)refreshButtonPre
{
    if(_delegate && [_delegate respondsToSelector:@selector(refreshButtonPressed)]) {
        [_delegate refreshButtonPressed];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_inputIpView removeFromSuperview];
    if(buttonIndex == 1) {
        if(_delegate && [_delegate respondsToSelector:@selector(inputMessage:message2:message3:message4:)]) {
            UITextField *textFiled = [alertView textFieldAtIndex:0];
            [_delegate inputMessage:textFiled.text message2:@"" message3:@"" message4:@""];
        }
    }
    
}

- (void)showInputIpView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入IP" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield = [alertView textFieldAtIndex:0];
    textfield.keyboardType = UIKeyboardTypeDecimalPad;
    [alertView show];
    

}

- (void)input
{
    [self showInputIpView];
}



- (void)searchServer
{
    UITextField *textField1 = (UITextField *)[_inputIpView viewWithTag:111];
    UITextField *textField2 = (UITextField *)[_inputIpView viewWithTag:112];
    UITextField *textField3 = (UITextField *)[_inputIpView viewWithTag:113];
    UITextField *textField4 = (UITextField *)[_inputIpView viewWithTag:114];

    for(int i = 0 ;i < 4; i ++) {
        UITextField *textFiled = (UITextField *)[_inputIpView viewWithTag:111 + i];
        
        if(textFiled.text == nil || textFiled.text.length == 0) {
            textFiled.placeholder = @"为空";
            return;
        }
    }
    if(_delegate && [_delegate respondsToSelector:@selector(inputMessage:message2:message3:message4:)]) {
        [_delegate inputMessage:textField1.text message2:textField2.text message3:textField3.text message4:textField4.text];
    }
    [_inputView removeFromSuperview];
}

- (void)cancelInputView
{
    for(int i = 0 ;i < 4; i ++) {
        UITextField *textFiled = (UITextField *)[_inputView viewWithTag:111 + i];
        [textFiled resignFirstResponder];
    }
    [_inputView removeFromSuperview];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str;
    if(string.length == 0) {
        str = [textField.text substringToIndex:textField.text.length - 1];
    } else {
        str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    if(str.length > 3) {
        return NO;
    }
    return YES;
}

@end
