//
//  NSDictionary+JSON.m
//  LeFangHousekeeper
//
//  Created by 王丹 on 2019/6/18.
//  Copyright © 2019 LeFang. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)


- (NSString *)dictJSON {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        return nil;
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    return mutStr;
}

@end
