//
//  UIImage+Reduce.m
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/9/9.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import "UIImage+Reduce.h"

@implementation UIImage (Reduce)


- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    //eate a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

//获取视频的第一帧截图, 返回UIImage
//需要导入AVFoundation.h
+ (instancetype) getVideoPreViewImageWithPath:(NSURL *)videoPath
{
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
//    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    gen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//    NSError *error = nil;
//    CMTime actualTime;
//    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    UIImage *img = [[UIImage alloc] initWithCGImage:image];
//    return img;
    return nil;
}

@end
