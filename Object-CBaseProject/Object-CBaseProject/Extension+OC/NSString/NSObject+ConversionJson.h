//
//  NSObject+ConversionJson.h
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/5/19.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ConversionJson)

/*数组转JSON格式
 
 */
+(NSString*)arrayToJson:(NSArray*)array;

+ (NSString *)stringfromArray:(NSArray<NSString *> *)array segement:(NSString *)str ;

//这个是url转码
+ (NSString *)urlTransformString:(NSString *)urlStr;

//字符串的url 编码
+(NSString *)decodeString:(NSString*)encodedString;

//字符串的URL 解码
+(NSString*)encodeString:(NSString*)unencodedString;

@end
