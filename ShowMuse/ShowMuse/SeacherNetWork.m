//
//  SeacherNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "SeacherNetWork.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"


@implementation SeacherNetWork

+(void)searchLessonWithOffset:(NSString *)offset search:(NSString *)search Complete:(completeSeacher)completeSeacher {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/lessons"]];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    NSDictionary * requestParameters = @{@"limit":@"10",@"offset":offset,@"search":search};
    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeSeacher) {
            completeSeacher(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeSeacher) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeSeacher(nil,error);
        }
    }];
    
}

+(void)teacherSearchNSString:(NSString *)search Complete:(completeSeacher)completeSeacher {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/teachers"]];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    NSDictionary * requestParameters = @{@"search":search};
    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeSeacher) {
            completeSeacher(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeSeacher) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeSeacher(nil,error);
        }
    }];

}

+(void)categoriesSearchLessonWithOffset:(NSString *)offset search:(NSString *)search category:(NSString *)category Complete:(completeSeacher)completeSeacher {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/lessons"]];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    NSDictionary * requestParameters = @{@"limit":@"10",@"offset":offset,@"search":search,@"category":category};
    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeSeacher) {
            completeSeacher(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeSeacher) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeSeacher(nil,error);
        }
    }];
    
}
@end
