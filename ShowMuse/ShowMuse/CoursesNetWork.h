//
//  CoursesNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/5/12.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completeCourses)(id json, NSError* error);
@interface CoursesNetWork : NSObject

//课程列表请求
+(void)CouesesDetailsWithID:(NSString *)courses Complete:(completeCourses)completeCourses;
@end
