//
//  UIWindow+ViewController.h
//  SixDegree
//
//  Created by zhangyong on 2017/12/7.
//  Copyright © 2017年 zhangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (ViewController)

//当前窗口视图控制器
+ (UIViewController *)topViewController;
//当前窗口
+ (UIViewController *)presentViewController;
@end
