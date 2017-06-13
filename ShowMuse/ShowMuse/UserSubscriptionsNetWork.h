//
//  UserSubscriptionsNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/5/25.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completeUserSub)(id json, NSError* error);
@interface UserSubscriptionsNetWork : NSObject

+(void)userSubscriptionsComplete:(completeUserSub)completeUserSub;
@end
