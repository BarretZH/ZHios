//
//  UserDetailsNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/5/23.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ShowMuseURLString.h"

typedef void(^completeUserDeta)(id json, NSError* error);

@interface UserDetailsNetWork : NSObject

//获取用户信息
+(void)userDetailsWithUserDeta:(completeUserDeta)completeUserDate;

//上传图片
+(AFHTTPRequestOperation* )PostRequestWithPicUrl:(NSString *)urlStr WithDict:(NSDictionary *)dict WithData:(NSArray* )images  ReturnData:(completeUserDeta)completeUserDeta;


+(void)userDetailsWithDic:(NSDictionary *)dic Complete:(completeUserDeta)completeUserDeta;
@end
