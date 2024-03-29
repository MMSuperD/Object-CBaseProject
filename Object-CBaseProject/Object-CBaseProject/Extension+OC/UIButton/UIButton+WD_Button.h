//
//  UIButton+WD_Button.h
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/8/24.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};
@interface UIButton (WD_Button)

/**
 * 设置button的titleLabel和imageView的布局样式，及间距
 *
 * @param style titleLabel和imageView的布局样式
 * @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;


/**
 创建一个Customer的Button

 @param title 标题
 @param corlorString 颜色 @"#ffffff"
 @param font 字体大小  12
 @return UIButton
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(NSString *)corlorString titleFont:(CGFloat)font;



@end
