//
//  TokenManager.h
//  ShowMuse
//
//  Created by show zh on 16/4/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenManager : NSObject

//存token
+(void)saveToken:(NSString *)token;
//取token
+(NSString *)getToken;
//删除token
+(void)deleteDataToken;
//存guset
+(void)saveeGuest:(BOOL)guest;
//取guest
+(BOOL)getGuest;

//存用户信息
+(void)saveUserDataWithName:(NSString *)name avatar:(NSString*)avatar premium:(NSString *)premium premiumStart:(NSString *)premiumStart premiumStop:(NSString *)premiumStop be_a_teacher_url:(NSString *)be_a_teacher_url messages:(NSArray *)messages messagesTotal:(NSInteger)messagesTotal premiumTime:(NSString *)premiumTime teacher_title:(NSString *)teacher_title;


+(void)saveUserdataWithDictionary:(NSDictionary *)dic;

@end
