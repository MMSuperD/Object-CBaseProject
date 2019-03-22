//
//  NSObject+ConversionJson.m
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/5/19.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import "NSObject+ConversionJson.h"

@implementation NSObject (ConversionJson)


+(NSString*)arrayToJson:(NSArray*)array

{
    
    NSError* parseError =nil;
    
    //options=0转换成不带格式的字符串
    
    //options=NSJSONWritingPrettyPrinted格式化输出
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (NSString *)stringfromArray:(NSArray<NSString *> *)array segement:(NSString *)str {

    if (array.count > 0) {
        
        NSMutableString *mulString = [NSMutableString string];
        
        for (NSString *temp in array) {
            
            [mulString appendFormat:@"%@%@",temp,str];
        }
        
        //现在是截取最后一个逗号
        mulString = [mulString substringToIndex:mulString.length - 1].mutableCopy;
        return mulString.copy;
        
    }
    
    return nil;
    
}

+ (NSString *)urlTransformString:(NSString *)urlStr {
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    
    NSString * encodedString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    return encodedString;
}

+(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end










