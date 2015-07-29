//
//  UploadPics.m
//  VoucherCollection
//
//  Created by yongzhang on 14-12-16.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "UploadPics.h"
#import "DetailLocal.h"
#import "DetailLocalDao.h"
#import "AFHTTPRequestOperationManager.h"
#import "ExamineIdenDao.h"
#import "ExamineIden.h"
#import "JSONKit.h"
#import "IPInfoDao.h"

@implementation UploadPics

+ (void)uploadPicsWith:(NSNumber *)iden pictures:(NSArray *)pictures ip:(NSString *)ipAddress block:(void (^)(NSInteger))block
{
    DetailLocal *detailLocal = [DetailLocalDao readDataWithIden:iden];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:detailLocal.dwid forKey:@"dwid"];
    [dic setValue:detailLocal.ndid forKey:@"ndid"];
    [dic setValue:detailLocal.kjyear forKey:@"kjyear"];
    [dic setValue:detailLocal.kjmonth forKey:@"kjmonth"];
    [dic setValue:detailLocal.pzbh forKey:@"pzbh"];
    [dic setValue:@1 forKey:@"pxh"];
    [dic setValue:detailLocal.bh forKey:@"bh"];
    [dic setValue:detailLocal.pzzl forKey:@"pzzl"];
    [dic setValue:@"a2b2755d2be2a70c187d300f14f09d27" forKey:@"key"];
    
    //上传核对信息
    NSArray *idenArray = [self backCheckArrayWithIp:ipAddress iden:iden];
    if(idenArray.count == 0) {
        [dic setValue:@0 forKey:@"check"]; 
    } else {
        [dic setValue:@1 forKey:@"check"];
    }
    
    NSString *jsonStr = [self backCheckJsonStringWithIp:ipAddress iden:iden];
    [dic setValue:jsonStr forKey:@"checkInfo"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:8080/pzcj/uploadVoucher.sht",ipAddress];
    
    [[self afManager] POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i = 0 ;i < pictures.count;i++) {
            UIImage *image = pictures[i];
            NSString *fileName = [NSString stringWithFormat:@"fileName%d",i];
                   [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:fileName fileName:[self backPicName] mimeType:@"image/png"];
        }
 
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSNumber *number = responseObject[@"code"];
        if ([number isEqual:@1]) {
            block(1);

        } else {
            block(2);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(2);
    }];
}

+ (NSMutableDictionary *)backTempDicParameters
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"" forKey:@"dwid"];
    [dic setValue:@"" forKey:@"ndid"];
    [dic setValue:@"" forKey:@"kjyear"];
    [dic setValue:@"" forKey:@"kjmonth"];
    [dic setValue:@"" forKey:@"pzbh"];
    [dic setValue:@0 forKey:@"pxh"];
    [dic setValue:@"" forKey:@"bh"];
    [dic setValue:@"" forKey:@"pzzl"];
    [dic setValue:@"a2b2755d2be2a70c187d300f14f09d27" forKey:@"key"];
    [dic setValue:@0 forKey:@"check"];
    [dic setValue:@"" forKey:@"checkInfo"];
    return dic;
}

+ (void)uploadTemPics:(NSArray *)pictures block:(void (^)(NSInteger))block
{
    __block NSInteger success = 0;//判断成功
    __block NSInteger fail = 0 ;//判断失败
    NSArray *ipInfos = [EntityOneDao readObjectWithEntityName:@"IPInfos" predicate:nil];
    if(ipInfos.count == 0) {
        block(3);
        return;
    }
    for(IPInfos *ipInfo in ipInfos) {
        NSString *ipAddress = ipInfo.ipAddress;
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:8080/pzcj/uploadVoucher.sht",ipAddress];
        NSMutableDictionary *paramters = [self backTempDicParameters];
    
    [[self afManager] POST:urlString parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i = 0 ;i < pictures.count;i++) {
            UIImage *image = pictures[i];
            NSString *fileName = [NSString stringWithFormat:@"fileName%d",i];
            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:fileName fileName:[self backPicName] mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSNumber *number = responseObject[@"code"];
        if ([number isEqual:@1]) {
            success ++;
            if(success == ipInfos.count) {
                block(1);
            } else {
                block(2);
            }
        } else {
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail ++;
        if(success + fail == ipInfos.count) {
        block(2);
        }
    }];
    }
}

+ (NSString *)backPicName
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *picName = [NSString stringWithFormat:@"%@.png",[df stringFromDate:date]];
    return picName;
}

+ (AFHTTPRequestOperationManager *)afManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    return manager;
}

//判断是否含有核对信息
+ (NSArray *)backCheckArrayWithIp:(NSString *)ipAddress iden:(NSNumber *)iden
{
    NSArray *examineidens = [ExamineIdenDao readDataFromIden:iden ipAddress:ipAddress];
    return examineidens;

}

+ (NSString *)backCheckJsonStringWithIp:(NSString *)ipAddress iden:(NSNumber *)iden
{
    NSArray *examineidens = [self backCheckArrayWithIp:ipAddress iden:iden];
    NSMutableArray *newArray = [NSMutableArray new];
    for( ExamineIden *examineIden in examineidens) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:examineIden.parId forKey:@"parid"];
        [dic setValue:examineIden.parname forKey:@"parname"];
        NSNumber *checkvalue = examineIden.hasCheck;
        if([checkvalue isEqual:@0]) {
            [dic setValue:@0 forKey:@"checkvalue"];
        } else {
            [dic setValue:@1 forKey:@"checkvalue"];
        }
        [newArray addObject:dic];
    }
    NSString *jsonStr = [newArray JSONString];
    return jsonStr;
}



@end
