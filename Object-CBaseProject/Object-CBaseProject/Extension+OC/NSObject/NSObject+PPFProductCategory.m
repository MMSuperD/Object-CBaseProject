//
//  NSObject+PPFProductCategory.m
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/5/8.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import "NSObject+PPFProductCategory.h"

@implementation NSObject (PPFProductCategory)

#pragma mark --发送通知
- (void)sendNotificationName:(NSString *)notificationName Object:(id)notificationObject {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:notificationObject];
}

- (void)sendNotificationName:(NSString *)notificationName object:(id)notificationObject useInfo:(id )useInfo {

    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:notificationObject userInfo:useInfo];
}

@end
