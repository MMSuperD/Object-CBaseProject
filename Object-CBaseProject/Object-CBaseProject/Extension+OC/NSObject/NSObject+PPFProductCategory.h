//
//  NSObject+PPFProductCategory.h
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/5/8.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PPFProductCategory)

//这个是发送搜索通知
- (void)sendNotificationName:(NSString *)notificationName Object:(id)notificationObject;

//这个是发送带字典的通知
- (void)sendNotificationName:(NSString *)notificationName object:(id)notificationObject useInfo:(id )useInfo ;

@end
