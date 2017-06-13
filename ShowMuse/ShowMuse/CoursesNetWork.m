//
//  CoursesNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/5/12.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "CoursesNetWork.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"

@implementation CoursesNetWork

//课程列表请求
+(void)CouesesDetailsWithID:(NSString *)coursesID Complete:(completeCourses)completeCourses {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@",[ShowMuseURLString URLStringWithPath:@"/v2/courses/"],coursesID];
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeCourses) {
            completeCourses(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeCourses) {
            
            error = [ShowMuseURLString errorWithPerform:error];
            
            completeCourses(nil,error);
        }
    }];
}











@end
