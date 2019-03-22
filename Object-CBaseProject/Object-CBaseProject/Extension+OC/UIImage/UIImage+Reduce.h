//
//  UIImage+Reduce.h
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/9/9.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Reduce)

//@property (nonatomic,strong)UIImagePickerController *imagePicker;

/**
 * 图片压缩
 */
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 * 视频截取
 */
+ (instancetype) getVideoPreViewImageWithPath:(NSURL *)videoPath;



@end
