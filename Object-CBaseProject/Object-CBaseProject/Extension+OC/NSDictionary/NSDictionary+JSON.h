//
//  NSDictionary+JSON.h
//  LeFangHousekeeper
//
//  Created by 王丹 on 2019/6/18.
//  Copyright © 2019 LeFang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JSON)


/**
 字典转JSON

 @return JSONString
 */
- (NSString *)dictJSON;

@end

NS_ASSUME_NONNULL_END
