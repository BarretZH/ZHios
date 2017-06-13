//
//  HomeNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/5/6.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completeHome)(id json, NSError* error);
@interface HomeNetWork : NSObject



//大师的请求
+(void)teachersNetWorkComplete:(completeHome)completeHome;

//问题请求
+(void)questionNetWorkWithOffset:(NSString *)offset Complete:(completeHome)completeHome;

//获取banner图
+(void)fullScreenBannersComplete:(completeHome)completeHome;
//告诉服务器干过的banner
+(void)postFullScreenBannersID:(NSString *)ID Complete:(completeHome)completeHome;
//菜单分类请求
+(void)caregoriesComplete:(completeHome) completeHome;
//关注按钮发送的请求
+(void)favouritesTeacherWithisPUT:(BOOL)isPUT teacherID:(NSString *)teacherID Complete:(completeHome) completeHome;
@end
