//
//  NetDataToEntity.m
//  VoucherCollection
//
//  Created by yongzhang on 14-11-12.
//  Copyright (c) 2014年 zy. All rights reserved.
//

#import "NetDataToEntity.h"

@implementation NetDataToEntity

//将网络请求回的数据转换成为模型的数据
+ (NSArray *)setMyValue:(NSArray*)array1 className:(NSString *)str
{
    
    Class MyClass = NSClassFromString(str);
    
    NSMutableArray *newArray = [NSMutableArray new];
    
    for (int i=0; i<array1.count; i++)
    {
        //降数据中每个元素用字典类型取出来
        NSDictionary *dics = array1[i];
        //新建一个模型类对象
        NSObject *obj = [MyClass new];
        //遍历字典中的key
        for(NSString *str in [dics allKeys])
        {
            //用模型类对象接收字典中的元素
            [obj setValue:dics[str] forKey:str];
        }
        //将模型对象添加到数组中并返回
        [newArray addObject:obj];
    }
    return newArray;
}

+ (id)setMyValue2:(NSDictionary *)dic className:(NSString *)str
{
    Class MyClass = NSClassFromString(str);

    NSObject *obj = [[MyClass alloc] init];
    for(NSString *str in [dic allKeys])
    {
        //用模型类对象接收字典中的元素
        [obj setValue:dic[str] forKey:str];
        
    }
    return obj;
}

@end
