//
//  UIWindow+ViewController.m
//  SixDegree
//
//  Created by zhangyong on 2017/12/7.
//  Copyright © 2017年 zhangyong. All rights reserved.
//

#import "UIWindow+ViewController.h"

@implementation UIWindow (ViewController)

+ (UIViewController *)topViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true)
    {
        if (topViewController.presentedViewController)
        {
            topViewController = topViewController.presentedViewController;
        }
        else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController])
        {
            topViewController = [(UINavigationController *)topViewController topViewController];
        }
        else if ([topViewController isKindOfClass:[UITabBarController class]])
        {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        }
        else
        {
            break;
        }
    }
    return topViewController;
}

+ (UIViewController *)presentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true)
    {
        if (topViewController.presentedViewController)
        {
            topViewController = topViewController.presentedViewController;
        }
        else
        {
            break;
        }
    }
    return topViewController;
}
@end
