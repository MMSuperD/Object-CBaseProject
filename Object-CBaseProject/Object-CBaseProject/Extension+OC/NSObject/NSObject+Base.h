//
//  NSObject+Base.h
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/7/21.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Base)

/**  
 *判断是否是电话号码
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 * 判断是否是邮箱
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 *创建一个Image
 */
- (UIImage *)imageWithImageName:(NSString *)imageName;

/**
 *提示框
 */
- (void)showMessage:(NSString *)message duration:(NSTimeInterval)time;

- (void)showMessage:(NSString *)message;

/**
 *计算label 的高度
 */

- (CGSize)calculateLabelSize:(CGFloat )size ;


/**
 * 返回虚线(UIImageView 画虚线)
 * 画虚线
 *创建一个imageView 高度是你想要的虚线的高度 一般设为2
 *_lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 2)];
 *调用方法 返回的iamge就是虚线
 *_lineImg.image = [self drawLineByImageView:_lineImg];
 *添加到控制器的view上
 *[self.view addSubview:_lineImg];
 *
 */
- (UIImage *)drawLineByImageView:(UIImageView *)imageView color:(UIColor *)color;

/**
 * 得到当前的控制器
 */
- (UIViewController *)getCurrentVC;

/**
 * 设置富文本属性
 */
- (NSMutableAttributedString *)getAttributedEntiryString:(NSString *)string leftString:(NSString *)leftString rightString:(NSString *)rightString font:(CGFloat )font;

/**
 * 当前时间
 */
- (NSString *)getCurrentTime;

/**
 * 根据字符串转化为时间NSDate
 */
- (NSDate *)dateFromString:(NSString *)dateString;

/**
 * 比较两个时间返回结果集
 */
- (NSDateComponents *)compareDate1:(NSDate *)date1 date2:(NSDate *)date2;

/**
 * 比较两个时间返回结果集
 */
- (NSDateComponents *)compareDateString1:(NSString *)dateString1 dateString2:(NSString *)dateString2 format:(NSString *)format;
@end









