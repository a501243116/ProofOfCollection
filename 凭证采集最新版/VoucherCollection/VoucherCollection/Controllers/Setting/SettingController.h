//
//  SettingController.h
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "BaseController.h"

@interface SettingController : BaseController

@property (strong, nonatomic) IBOutlet UISlider *slider;//图片保存质量
@property (strong, nonatomic) IBOutlet UISwitch *switchOne;//上传服务器清空照片
@property (strong, nonatomic) IBOutlet UISwitch *switchTwo;//拍照自动弹出核对界面

@property (strong, nonatomic) IBOutlet UISwitch *switchThree;//凭证核对全选进入下一条凭证

@end
