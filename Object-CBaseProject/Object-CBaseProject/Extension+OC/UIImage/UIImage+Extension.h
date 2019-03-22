//
//  UIImage+Extension.h
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 * 将图片裁剪为正方形
 */
- (UIImage *)clipImageInSquare;
/**
 * 裁剪到2：1
 */
- (UIImage *)clipImageInTwo_OneSquare;
/**
 * 按照给与的比例裁剪
 * @param scale 裁剪的长宽比
 * @return 
 */
- (UIImage *)clipImageInScale:(CGFloat)scale;
/**
 * 截屏
 */
+ (UIImage *)captureWithView:(UIView *)view;
/**
 * 图片压缩
 */
- (UIImage *)scaleImage;
/**
 * 根据颜色生成图片
 */
- (UIImage *)creatImageWithColor:(UIColor *)color;
+ (UIImage *)creatImageWithColor:(UIColor *)color;

/**
 *  返回圆形图片
 */
- (instancetype)circleImage;
- (UIImage *)circleImageInSize:(CGSize)size;

+ (instancetype)circleImage:(NSString *)name;

- (UIImage *)compressTargetWidth:(CGFloat)defineWidth;
/** 返回动图   */
+ (UIImage*)gifImageWithData:(NSData*)data;
+ (UIImage*)gifImageWithData:(NSData*)data duration:(CGFloat)duration;
@end
