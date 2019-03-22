//
//  NSArray+ZFBAddition.m
//  01-支付宝
//
//  Created by teacher on 16/9/1.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "NSArray+ZFBAddition.h"

@implementation NSArray (ZFBAddition)
+ (instancetype)hm_arrayWithPlistName:(NSString *)plistName className:(NSString *)className{
    // 1. 获取plist文件的地址
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"businessType.plist" ofType:nil];
    NSURL *url = [[NSBundle mainBundle]URLForResource:plistName withExtension:nil];
    // 2. 加载Plist字典集合
    NSArray *dictArr = [NSArray arrayWithContentsOfURL:url];
    
    // 3. 遍历字典集合，创建模型对象，添加到一个可变数组红
    NSMutableArray *modelArrM = [NSMutableArray array];
    [dictArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
//        ZFBBusinessTypeModel *model = [ZFBBusinessTypeModel businessTypeWithDict:dict];
        Class clz = NSClassFromString(className);
        
        NSObject *obj = [[clz alloc]init];
        
        [obj setValuesForKeysWithDictionary:dict];
        //[model setValuesForKeysWithDictionary:dict];
        //model.name = dict[@"name"];
        //mode.icon = dict[@"icon"];
        
        [modelArrM addObject:obj];
    }];

    return modelArrM.copy;

}
@end
