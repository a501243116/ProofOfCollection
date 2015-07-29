//
//  InputPwdController.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-11.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "InputPwdController.h"
#import "PwdTextField.h"
#import "ServerInfo.h"
#import "EntityOneDao.h"
#import "IPInfoDao.h"
#import <CommonCrypto/CommonDigest.h>
#import "TaskController.h"
@interface InputPwdController ()<UITextFieldDelegate>
{
    PwdTextField *_textField;
    BOOL _logining;//正在登录中
}

@end

@implementation InputPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logining = NO;
    [self initializeDataSource];
    [self initializeApperance];
}

- (void)initializeApperance
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.title = @"输入密码";
    
    //初始化自定的密码框
    _textField = [[PwdTextField alloc] initForAutoLayout];
    [self.view addSubview:_textField];
    [_textField autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:0.9];
    [_textField autoSetDimension:ALDimensionHeight toSize:40];
    [_textField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_textField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
    [_textField layoutIfNeeded];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.layer.cornerRadius = 5;
    _textField.placeholder = @"请输入登录密码";
    _textField.delegate = self;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.secureTextEntry = YES;
//    _textField.text = @"pkey";
    
    //确定按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button autoSetDimension:ALDimensionHeight toSize:40];
    [button autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:0.9];
    [button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_textField withOffset:15];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_confirm.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonPressed:(UIButton *)sender
{
    if(_logining) {
        [self showAlertWithMessage:@"请不要重复登录"];
    }
    _logining = YES;
    
    [self.netDic setValue:@"a2b2755d2be2a70c187d300f14f09d27" forKey:@"key"];
    [self.netDic setObject:[self md5HexDigest:_textField.text] forKey:@"passKey"];
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080/pzcj/computerLogin.sht",_ipAddress];
    [self.manager POST:urlStr parameters:self.netDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseData:responseObject];
        _logining = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertWithMessage:@"网络错误"];
        _logining = NO;
    }];
}

-(NSString *) md5HexDigest:(NSString *)pwd

{
    
    const char *original_str = [pwd UTF8String];
    
    unsigned char result[CC_MD5_BLOCK_BYTES];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
        [hash appendFormat:@"%02X", result[i]];
    
    return hash;
    
}

- (void)parseData:(NSDictionary *)dic
{
    if([dic[@"code"] isEqual:@0]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        ServerInfo *info = [NetDataToEntity setMyValue2:dic[@"data"] className:NSStringFromClass([ServerInfo class])];
        
        //存入数据库
        [IPInfoDao createIPInfo:self.ipAddress computerName:info.jsjName];
        
        //保存地址在userdefauls里面
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *ipSave = [NSString stringWithFormat:@"http://%@:8080",_ipAddress];
        [defaults setValue:ipSave forKey:@"rootUrl"];
        [defaults synchronize];
        
        if(_delegate && [_delegate respondsToSelector:@selector(backJsJID:)]) {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:info.jsjID forKey:_ipAddress];
            [_delegate backJsJID:dictionary];
        }
        [[NSUserDefaults standardUserDefaults] setValue:[self md5HexDigest:_textField.text] forKey:_ipAddress];
        if(_isFirst)
        {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TaskController *taskController = (TaskController *)[storyBoard instantiateViewControllerWithIdentifier:@"task"];
            taskController.ipAdress = _ipAddress;

            [self.navigationController pushViewController:taskController animated:YES];
        }else
            [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//点击之后收起键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [_textField resignFirstResponder];
}

@end
