//
//  SMUserBadges.h
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completeUserBadges)(id json, NSError* error);


@interface SMUserBadgesNetWork : NSObject
/**
 *  用户徽章请求
 *
 *
 */
+(void)userBadgesDataWithComplete:(completeUserBadges)completeUserBadges;
@end
