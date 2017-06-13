//
//  UserNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/5/20.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completeUSER)(id json, NSError* error);
@interface UserNetWork : NSObject


+(void)CouesesDetailsWithOffset:(NSString *)offset Complete:(completeUSER)completeUSER;

@end
