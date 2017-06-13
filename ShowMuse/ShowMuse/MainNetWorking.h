//
//  MainNetWorking.h
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^complete)(id json, NSError* error);
@interface MainNetWorking : NSObject

//版本更新
+ (void)versionUpdateComplete:(complete)complete;

////第三方登录
//+ (void)thirdPartyLoginWithGrantType:(NSString *)grant_type UserID:(NSString *)user_id UserAccessToken:(NSString *)user_access_token Complete:(complete)complete;

//判断是否有新的导航图
+ (void)syncbannersComplete:(complete)complete;


//用户请求
+(void)userDataNetWorkComplete:(complete)complete;


+(void)versionID;
@end
