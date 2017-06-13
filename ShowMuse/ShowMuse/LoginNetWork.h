//
//  LoginNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^complete)(id json, NSError* error);
@interface LoginNetWork : NSObject



//第三方登录
+ (void)thirdPartyLoginWithGrantType:(NSString *)grant_type UserID:(NSString *)user_id UserAccessToken:(NSString *)user_access_token Complete:(complete)complete;
//游客登录
+ (void)guestLoginComplete:(complete)complete;
//账号登录
+ (void)accountLoginWithUserName:(NSString *)username password:(NSString *)password complete:(complete)complete;
//注册
+ (void)registerWithEmail:(NSString *)email password:(NSString *)password complete:(complete)complete;
//- (void)httpWithURLString:(NSString *)URLString requestParameters:(NSDictionary *)requestParameters complete:(complete)complete;
#pragma mark - 忘记密码
+ (void)resetPasswordWithEmail:(NSString *)email complete:(complete)complete;
@end
