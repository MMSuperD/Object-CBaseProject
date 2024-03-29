//
//  UIColor+ZFBAddition.h
//  01-支付宝
//
//  Created by teacher on 16/8/31.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZFBAddition)
+ (instancetype)hm_colorWithHex:(uint32_t)hex;
+ (instancetype)hm_colorWithR:(int)red G:(int)green B:(int)blue alpha:(float)alpha;
+ (instancetype)hm_randomColor;
+ (instancetype)colorWithHexString: (NSString *)color;
@end
