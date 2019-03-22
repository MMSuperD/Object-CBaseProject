//
//  NSObject+Base.m
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/7/21.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import "NSObject+Base.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation NSObject (Base)

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

/**
 * 是否是邮箱
 */
+ (BOOL)isEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

- (UIImage *)imageWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

- (CGSize)calculateLabelSize:(CGFloat)size {
    
    UILabel *label = [UILabel new];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:size]};
    CGSize size1=[label.text sizeWithAttributes:attrs];
    return size1;
}

// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView color:(UIColor *)color {
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    double  length[] = {20,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, color.CGColor);
    CGContextSetLineDash(line, 0, length, 2); //画虚线
 
    CGContextMoveToPoint(line, 0.0, 2.0); //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH - 10, 2.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
  
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (UIViewController *)getCurrentVC {
    
    for (UIWindow *window in [UIApplication sharedApplication].windows.reverseObjectEnumerator) {
        
        UIView *tempView = window.subviews.lastObject;
        
        for (UIView *subview in window.subviews.reverseObjectEnumerator) {
            if ([subview isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
                tempView = subview;
                break;
            }
        }
        
        BOOL(^canNext)(UIResponder *) = ^(UIResponder *responder){
            if (![responder isKindOfClass:[UIViewController class]]) {
                return YES;
            } else if ([responder isKindOfClass:[UINavigationController class]]) {
                return YES;
            } else if ([responder isKindOfClass:[UITabBarController class]]) {
                return YES;
            } else if ([responder isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
                return YES;
            }
            return NO;
        };
        
        UIResponder *nextResponder = tempView.nextResponder;
        
        while (canNext(nextResponder)) {
            tempView = tempView.subviews.firstObject;
            if (!tempView) {
                return nil;
            }
            nextResponder = tempView.nextResponder;
        }
        
        UIViewController *currentVC = (UIViewController *)nextResponder;
        if (currentVC) {
            return currentVC;
        }
    }
    return nil;
    
}

- (NSMutableAttributedString *)getAttributedEntiryString:(NSString *)string leftString:(NSString *)leftString rightString:(NSString *)rightString font:(CGFloat )font {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange leftRange;
    if (leftString.length || leftString != nil) {
        leftRange = [string rangeOfString:leftString];
    }else {
        leftRange = NSMakeRange(0, 0);
    }
    NSRange rightRange = [string rangeOfString:rightString];
    NSRange endRange = NSMakeRange(leftRange.location + leftRange.length, rightRange.location - leftRange.location - leftRange.length);
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:endRange];
    return attributedStr;
}


//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

// 字符串转化为时间日期
- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//比较两个时间
- (NSDateComponents *)compareDate1:(NSDate *)date1 date2:(NSDate *)date2 {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //这个时间格式需要和当前得到时间格式相同才能做比较
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:date1];
    NSString *anotherDayStr = [dateFormatter stringFromDate:date2];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:dateA toDate:dateB options:0];
    
    return dateCom;
}

- (NSDateComponents *)compareDateString1:(NSString *)dateString1 dateString2:(NSString *)dateString2 format:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSDate *dateA = [dateFormatter dateFromString:dateString1];
    NSDate *dateB = [dateFormatter dateFromString:dateString2];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:dateA toDate:dateB options:0];
    
    return dateCom;
    
}








@end
