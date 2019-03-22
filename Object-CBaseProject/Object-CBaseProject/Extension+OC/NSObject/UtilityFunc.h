//
//  UtilityFunc.h
//  JHWAssistant
//
//  Created by Magician on 2017/2/22.
//  Copyright © 2017年 jugame. All rights reserved.
//
/**
 *  公共函数方法 全类通用
 */

#import <UIKit/UIKit.h>
//#import "UNEnum.h"

@interface UtilityFunc : NSObject

#pragma mark 计算出字体的长度已经高度。这里不包括行距
/**
 *  计算出字体的长度已经高度。这里不包括行距
 *
 *  @param string  字体
 *  @param font    字体大小
 *  @param maxSize label最大的宽度和高度
 *
 *  @return 字体的CGsize
 */
+ (CGSize)calculationOfTheText:(NSString *)string withFont:(CGFloat)font withMaxSize:(CGSize)maxSize;
/**
 *  计算出字体的长度已经高度。并且要设置行距。会对Lable进行处理。返回宽度和高度可以不用处理。
 *
 *  @param string  字体
 *  @param label   目标Lable
 *  @param font    字体大小
 *  @param width label最大的宽度
 *  @param spacing 行距
 *
 *  @return 处理过的Lable
 */
+ (CGRect)calculationOfTheText:(NSString *)string inLabel:(UILabel *)label withFont:(CGFloat)font withMaxWidth:(CGFloat)width withLineSpacing:(CGFloat)spacing;

+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

+ (NSArray *)getSeparatedLinesWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth;
/**
 *  设置导航条的颜色,已经隐藏导航条下面的线了
 *
 *  @param color  颜色
 *  @param target 直接传self
 */
#pragma mark 设置导航条的颜色
+(void)setNavigationBarColor:(UIColor *)color withTargetViewController:(id)target;
#pragma mark scrollView顶部视图下拉放大
/**
 *  scrollView顶部视图下拉放大
 *
 *  @param imageView  需要放大的图片
 *  @param headerView 图片所在headerView 如果没有则传图片自己本身
 *  @param height     图片的高度
 *  @param offsetY    设置偏移多少开始形变  例如是：offset_y = 64 说明就是y向下偏移64像素开始放大
 *  @param scrollView 对应的scrollView
 */
+(void)setHeaderViewDropDownEnlargeImageView:(UIImageView *)imageView withHeaderView:(UIView *)headerView withImageViewHeight:(CGFloat)height withOffsetY:(CGFloat)offsetY withScrollView:(UIScrollView *)scrollView;

/**
 *  名片详情弹出的UIAlertController视图 下标为0就是取消 1就是其他按钮
 *
 *  @param title              标题
 *  @param cancelStr          取消按钮
 *  @param otherBthStr        other按钮
 *  @param message            提示信息
 *  @param completionCallback （下标为0就是取消 1就是其他按钮）
 *
 *  @return UIAlertController
 */
+(UIAlertController *)createAlertViewWithTitle:(NSString *)title withCancleBtnStr:(NSString *)cancelStr withOtherBtnStr:(NSString *)otherBthStr withOtherBtnColor:(UIColor *)otherBtnColor withMessage:(NSString *)message completionCallback:(void (^)(NSInteger index))completionCallback;


/**
 *  传入当前控制器 传入同一个NAV的控制器类名 返回指定控制器
 *
 *  @param viewControllerName 控制器的类名
 *  @param viewController     当前控制器
 *
 *  @return UIViewController
 */
+(UIViewController *)getTargetViewController:(NSString *)viewControllerName withInTheCurrentController:(UIViewController *)viewController;
/**
 *  传入时间戳1296057600和输出格式 yyyy-MM-dd HH:mm:ss
 *
 *  @param seconds @"1296057600"
 *  @param format  @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 返回格式化的日期字符串
 */
+ (NSString *)dateWithTimeIntervalSince1970:(NSTimeInterval)seconds dateStringWithFormat:(NSString *)format;


// 是否4英寸屏幕
+ (BOOL)is4InchScreen;

// 获取屏幕宽度/高度
+ (CGFloat)getScreenWidth;
+ (CGFloat)getScreenHeight;

// 日期转字符串
+ (NSString *)getStringFromDate:(NSDate *)date byFormat:(NSString *)strFormat;
// 字符串转日期
+ (NSDate *)getDateFromString:(NSString *)strDate byFormat:(NSString *)strDateFormat;

// label设置最小字体大小
+ (void)label:(UILabel *)label setMiniFontSize:(CGFloat)fMiniSize forNumberOfLines:(NSInteger)iLines;

// 清除PerformRequests和notification
+ (void)cancelPerformRequestAndNotification:(UIViewController *)viewCtrl;

// 重设scroll view的内容区域和滚动条区域
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar;
// 按找状态栏高度的倍数来重设scroll view的内容区域和滚动条区域
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetStatusBarTimes:(NSInteger)contentTimes indicatorInsetStatusBarTimes:(NSInteger)indicatorTimes;
// 指定高度重设内容区域和滚动条区域
+ (void)resetScrlView:(UIScrollView *)sclView contentInset:(CGFloat)contentInset indicatorInset:(CGFloat)indicatorInset;

////获取MainStoryboard中的UIViewController
+ (id)viewCtrlFormStoryboard:(NSString *)storyboardName viewCtrlID:(NSString *)viewCtrlID;
+(id)getControllerWithIdentity:(NSString *)identifier storyboard:(NSString *)title;
id getController(NSString *identifier,NSString *title);

//获取App窗口
+(UIWindow *)getWindow;


// 创建UILabel
+ (UILabel *)createLabelWithFrame:(CGRect)rc fontSize:(CGFloat)fFontSize txtColor:(UIColor *)clrTxt;
+ (UILabel *)createLabelWithFrame:(CGRect)rc fontSize:(CGFloat)fFontSize txtColor:(UIColor *)clrTxt isBoldFont:(BOOL)bIsBold;
+ (UILabel *)createLabelWithFrame:(CGRect)rc fontSize:(CGFloat)fFontSize txtColor:(UIColor *)clrTxt isBoldFont:(BOOL)bIsBold txtAlignment:(NSTextAlignment)alignment;

// 心跳动画
+ (void)heartbeatView:(UIView *)view duration:(CGFloat)fDuration;
+ (void)heartbeatView:(UIView *)view duration:(CGFloat)fDuration maxSize:(CGFloat)fMaxSize durationPerBeat:(CGFloat)fDurationPerBeat;

// Table滚动时TableCell内ImageView视差显示
+ (void)cell:(UITableViewCell *)cell onTableView:(UITableView *)tableView didScrollOnView:(UIView *)view parallaxImgView:(UIImageView *)imgView;

// 解析出URL的参数
+ (NSDictionary *)paramFromURL:(NSURL *)URL;

// 创建编辑框
+ (UITextField *)createNormalTextFieldWithFrame:(CGRect)rcFrame placeHolder:(NSString *)strPlaceholder;
+ (UITextField *)createNormalTextFieldWithFrame:(CGRect)rcFrame placeHolder:(NSString *)strPlaceholder keyboardType:(UIKeyboardType)eKeyboardType;

// 下拉选择样式的按钮
+ (void)setDropdownItemBtnStyle:(UIButton *)btn;
+ (void)setDropdownItemBtnStyle:(UIButton *)btn isContentAlignmentLeft:(BOOL)bIsAlignmentLeft;

// 视图添加一个光晕
+ (void)viewShowRedShadow:(UIView *)view;
+ (void)view:(UIView *)view showShadowWithColor:(UIColor *)color;
+ (void)viewRemoveShadow:(UIView *)view;

//获取是否开启推送通知
+ (BOOL)judgeNotification;

// 计算两坐标点间的距离
+ (CGFloat)distanceFromLat:(CGFloat)fromLat lng:(CGFloat)fromLng toLat:(CGFloat)toLat lng:(CGFloat)toLng;
+ (NSString *)distanceStrFromLat:(CGFloat)fromLat lng:(CGFloat)fromLng toLat:(CGFloat)toLat lng:(CGFloat)toLng;

// 统一生产UIFont
+ (UIFont *)createFontWithSize:(CGFloat)size;
+ (UIFont *)createBoldFontWithSize:(CGFloat)size;

// 十六进制字符串转颜色
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert defaultColor:(UIColor *)defaultColor;

//年龄
+ (NSString*)fromDateToAge:(NSDate*)date;

//创建新的Label
+ (UILabel *)getNewLabelWithTextColor:(UIColor *)color font:(UIFont *)font;
+ (BOOL)isAppCameraAccessAuthorized;
//+ (BOOL)isAppPhotoLibraryAccessAuthorized;
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSString *)priceString:(id)object;

//+ (CGFloat)calculateTotalAmountWithAmount:(NSNumber *)amount rate:(NSNumber *)rate ratio:(NSNumber *)ratio type:(UNTradeType)type;


/**
 重新解码链接，防止连接中出现中文而出现无法访问的现象
 
 @param urlString 链接
 @return 重新编码的链接
 */
+ (NSString *)encodedStringWithUrlString:(NSString *)urlString;

@end
